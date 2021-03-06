#!/usr/bin/env python

import json
from mimetypes import guess_type
import subprocess

from flask import abort

import app_config
import copytext
from flask import Blueprint
from render_utils import flatten_app_config

static = Blueprint('static', __name__)

def node():
    """
    Select correct node binary name for current platform.
    """
    if app_config.DEPLOYMENT_TARGET:
        # Ubuntu
        return 'nodejs'
    else:
        # OSX
        return 'node'

# Render JST templates on-demand
@static.route('/js/templates.js')
def _templates_js():
    output = subprocess.check_output([node(), 'node_modules/universal-jst/bin/jst.js', '--template', 'underscore', 'jst'])

    return output, 200, { 'Content-Type': 'application/javascript' }

# Render LESS files on-demand
@static.route('/less/<string:filename>')
def _less(filename):
    try:
        with open('less/%s' % filename):
            pass 
    except IOError:
        abort(404)

    output = subprocess.check_output([node(), 'node_modules/less/bin/lessc', 'less/%s' % (filename)])

    return output, 200, { 'Content-Type': 'text/css' }

# Render application configuration
@static.route('/js/app_config.js')
def _app_config_js():
    config = flatten_app_config()
    js = 'window.APP_CONFIG = ' + json.dumps(config)

    return js, 200, { 'Content-Type': 'application/javascript' }

# Render copytext
@static.route('/js/copy.js')
def _copy_js():
    copy = 'window.COPY = ' + copytext.Copy(app_config.COPY_PATH).json()

    return copy, 200, { 'Content-Type': 'application/javascript' }

# Server arbitrary static files on-demand
@static.route('/<path:path>')
def _static(path):
    try:
        with open('www/%s' % path) as f:
            return f.read(), 200, { 'Content-Type': guess_type(path)[0] }
    except IOError:
        abort(404)

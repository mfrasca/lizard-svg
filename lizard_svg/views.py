# (c) Nelen & Schuurmans.  GPL licensed, see LICENSE.txt.
from django.http import HttpResponse
from django.template import loader, RequestContext
from django.shortcuts import redirect

# Create your views here.

def overview(request, svg_name):
    if svg_name is None:
        return redirect('/overzicht')
    t = loader.get_template('lizard_svg/index.html')
    c = RequestContext(request, {
        'svg_dot_svg': svg_name + ".svg",
        'initialize_dot_js': "overzicht.js",
    })
    return HttpResponse(t.render(c))

def stroomschema_rwzi(request, svg_name):
    t = loader.get_template('lizard_svg/index.html')
    c = RequestContext(request, {
        'svg_dot_svg': "stroomschema_rwzi_" + svg_name + ".svg",
        'initialize_dot_js': "stroomschema_rwzi.js",
    })
    return HttpResponse(t.render(c))

def stroomschema(request, svg_name):
    t = loader.get_template('lizard_svg/index.html')
    c = RequestContext(request, {
        'svg_dot_svg': svg_name + ".svg",
        'initialize_dot_js': "stroomschema.js",
    })
    return HttpResponse(t.render(c))

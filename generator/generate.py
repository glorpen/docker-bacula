import argparse
import jinja2
import sys
import pathlib
import re
from glorpen.config import Config as GConfig
import glorpen.config.loaders as loaders
import glorpen.config.fields.simple as fields_simple

bacula_version = "9.4.1"
bacula_url = "https://blog.bacula.org/download/6572/"

re_line = re.compile("(\s*\n\s*)+")
def filter_oneline(value):
    return re_line.sub(" ", value.strip())

class Renderer(object):
    def __init__(self):
        super(Renderer, self).__init__()
        
        self._root_dir = pathlib.Path(__file__).parent
        
        self.env = jinja2.Environment(
            loader=jinja2.FileSystemLoader(self._root_dir.as_posix()),
        )
        self.env.filters["oneline"] = filter_oneline
    
    def load_config(self):
        config_path = (self._root_dir / "config.yml").as_posix()
        cfg = self._load_config(config_path)
        self._config = cfg
        
    def _load_config(self, config_path):
        loader = loaders.YamlLoader(filepath=config_path)
        spec = fields_simple.Dict({
            "targets": fields_simple.Dict(
                keys = fields_simple.String(),
                values = fields_simple.Dict({
                    "base_image": fields_simple.String(),
                    "system": fields_simple.String(),
                    "bacula_component": fields_simple.String(),
                    "template": fields_simple.String(allow_blank=True)
                })
            )
        })
        return GConfig(loader=loader, spec=spec).finalize()

    
    def render(self, mode):
        vars = self._config.get("targets").get(mode)
        tpl_name = "%s.dockerfile.jinja2" % (vars.get("template") if vars.get("template") else vars.get("system"))
        tpl = self.env.get_template(tpl_name)
        vars.update({
            "install_dir": "/opt/bacula",
            "bacula_version": bacula_version,
            "bacula_url": bacula_url
        })
        return tpl.render(vars)

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("set_name")
    p.add_argument('--destination', '-d', action="store", default=None)
    
    ns = p.parse_args()
    
    r = Renderer()
    r.load_config()
    sys.stdout.write(r.render(ns.set_name))

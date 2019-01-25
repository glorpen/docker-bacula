import argparse
import jinja2
import sys
import pathlib

class Renderer(object):
    def __init__(self):
        super(Renderer, self).__init__()
        
        self._root_dir = pathlib.Path(__file__).parent
        
        self.env = jinja2.Environment(
            loader=jinja2.FileSystemLoader(self._root_dir.as_posix()),
        )
    
    def render(self, mode):
        tpl = self.env.get_template("bacula.dockerfile.jinja2")
        return tpl.render({
            "mode": mode
        })

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("mode", choices=["storage", "director", "client"])
    p.add_argument('--destination', '-d', action="store", default=None)
    
    ns = p.parse_args()
    
    r = Renderer()
    sys.stdout.write(r.render(ns.mode))

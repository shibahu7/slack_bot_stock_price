using Pkg
Pkg.activate(".")
ENV["PYTHON"] = ""
Pkg.instantiate()
Pkg.precompile()

using PyCall
Pkg.build("PyCall")

using Conda
Conda.add("beautifulsoup4")

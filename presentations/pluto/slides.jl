### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 5287cbd6-4f47-11eb-3e96-a70de25fc446
using PlutoUI

# ╔═╡ f84b8ad4-4c78-11eb-2981-edac56ec8e33
md"## Why?"

# ╔═╡ 5faec94a-4c79-11eb-1024-994c009767f1
md""" 
> The power to understand and predict the quantities of the world should not be restricted to those with a freakish knack for manipulating abstract symbols.
>> Bret Victor, Computer Scientist 
"""

# ╔═╡ 0d3819d0-4ca6-11eb-3125-29938dcc7854
md"""
- Abstractions lead to complex code structures.
- logs, debuggers, tests ..... bleh
"""

# ╔═╡ e38ff548-4ca6-11eb-3dd8-630c05d29035
md""" Programming *may not become easy*, since the ideas we express through it may be irreducibly complex. """ 

# ╔═╡ ffccd4fe-4ca8-11eb-37cd-9dd5f0caeda5
md""" 
What we can do is reduce the cognitive burden of coding.[^1]
"""

# ╔═╡ 01d7b76e-4cdb-11eb-0668-dd07c0f9e436
md"""[^1]: Mike Bostock, A Better Way to Code (2017)"""

# ╔═╡ 3058dc6a-4c79-11eb-0dfe-156d42a74ccd
md"## Notebooks"

# ╔═╡ ba9a5042-4cd4-11eb-2e74-430975156698
md"""
#### Jupyter
"""

# ╔═╡ 66ce5514-4cd7-11eb-3e42-f9a171afd502
md"""
**Great for**
- interactivity (for its REPL like behaviour)
- Code, outputs & text all together
"""

# ╔═╡ 9d4a2a14-4cd7-11eb-3aa2-0967b982b4e8
md"""
**Not so great for**
- Global scope is persistent
- File format is .ipynb
- Compatibility issues
"""

# ╔═╡ 281011ec-4cd9-11eb-22c9-e3adae18d456
md"""## Alternatives
**Cloud-based notebooks** (Google Colab,etc)
- Reproducible
- Can run locally
- But still the same **programming environment**
"""

# ╔═╡ de878830-4cd9-11eb-2a3c-5f47c7cbf7bc
md"""For JavaScript: (ObservableHQ, prev:DS3.express)
- Effective new paradigms: *reactivity*, hot reload, blocks
- Not really a "*Scientific Computing langauge*" 
"""

# ╔═╡ 6f0eecee-4cdb-11eb-36d9-91c896b7617b
md""" 
# Pluto.jl 
"""

# ╔═╡ 8bf955f6-4cdb-11eb-0e10-db7dec48150d
md"""
- **Reactive** Julia notebooks inspired by ObservableHQ
- **Just .jl files** -- version control
- Download from Julia Pkg manager (FREE!)
"""

# ╔═╡ aeeb976a-4cde-11eb-1596-f3c9360955e1
md"""## Reactivity"""

# ╔═╡ 90815c32-4f3f-11eb-3487-f9e114b6a9f9
md"""
Each piece of state in a reactive program defines how it is calculated, and the runtime manages their evaluation.
"""

# ╔═╡ 34592828-4f4f-11eb-093e-9d1cdd17beff
t=3

# ╔═╡ e9aa3024-4f67-11eb-132b-cb309ec23ff2
t

# ╔═╡ ee80342e-4f67-11eb-31de-c5192e87f7e6
f = t*2

# ╔═╡ 2013a0ea-4f76-11eb-38ab-09c3ed0319f5
md""" This requires:
1. **Re-evaluate** all downstream cells using a dependency graph.
"""

# ╔═╡ a00ac636-4f44-11eb-1461-adb11d4c6430
md"""
![cell order](https://raw.githubusercontent.com/arv-n/banana-talk/master/graphics/screen_grab.png?token=ANRV5FPQ2NMQNV62B2HJ4ZK76R3C4)"""

# ╔═╡ 3be9dd0e-4f76-11eb-09d4-a1f5d49bbc79
md"""2. **Clean up** old code."""

# ╔═╡ aa34d5f2-4f76-11eb-0a46-49123556f056
var = true

# ╔═╡ 465b35da-4f76-11eb-0f4c-c1abb3adfe6b
if var
	md"var is defined"
else 
	md"var is not defined"
end

# ╔═╡ 653e2074-4f45-11eb-254a-b9404b525f35
md"""
- Same concept here as well of dependency graph
- tells us here which scope effects to revert"""

# ╔═╡ 98a9e00e-4f45-11eb-29a6-8760cc83fbe3
md"""## Interactivity"""

# ╔═╡ d0067ec4-4f45-11eb-1daf-1379f4e91db0
md"""Automatic interactivity between *cells*"""

# ╔═╡ f44642e4-4f45-11eb-3747-4d1ff8ad3c89
name = "Euler s Formula"

# ╔═╡ 88af08ee-4f62-11eb-27b1-9f92a7a3bc76
date = "6th Jan"

# ╔═╡ f625f79c-4f45-11eb-1088-2bcc4a295cbd
md"SIAM Delft banana talk on **$(name)** on $(date)"

# ╔═╡ 07172b66-4f46-11eb-2ff3-e3c710b8495e
md"""## Interactivity"""

# ╔═╡ 1ce7e55c-4f46-11eb-2e23-a31bd56528ba
md""" JavaScript widgets!!"""

# ╔═╡ e218adee-4f48-11eb-1a37-4dc87eca40ff
@bind dims html"""
<canvas width="200" height="200" style="position: relative"></canvas>

<script>
// 🐸 `currentScript` is the current script tag - we use it to select elements 🐸 //
const canvas = currentScript.closest('pluto-output').querySelector("canvas")
const ctx = canvas.getContext("2d")

var startX = 80
var startY = 40

function onmove(e){
	// 🐸 We send the value back to Julia 🐸 //
	canvas.value = [e.layerX - startX, e.layerY - startY]
	canvas.dispatchEvent(new CustomEvent("input"))

	ctx.fillStyle = '#ffecec'
	ctx.fillRect(0, 0, 200, 200)
	ctx.fillStyle = '#3f3d6d'
	ctx.fillRect(startX, startY, ...canvas.value)
}

canvas.onmousedown = e => {
	startX = e.layerX
	startY = e.layerY
	canvas.onmousemove = onmove
}

canvas.onmouseup = e => {
	canvas.onmousemove = null
}

// Fire a fake mousemoveevent to show something
onmove({layerX: 130, layerY: 160})

</script>
"""

# ╔═╡ 341a6378-4f49-11eb-025e-3b9283994151
dims

# ╔═╡ 350868a2-4f49-11eb-1814-db8671064552
area = dims[1]*dims[2]

# ╔═╡ c74db2da-4f62-11eb-3f9b-0f76e1c77d86
@bind x NumberField(1:10)

# ╔═╡ d5fbac10-4f62-11eb-00b5-9f561d89a04d
md"""Sum of first _$(x)_ natural numbers is **$(sum(1:x))**"""

# ╔═╡ 96254060-4f49-11eb-17a8-b1698e01fbb7
md"""## A more conventional example"""

# ╔═╡ 88a9054e-4f61-11eb-36e0-a7627efdfc16
md"""[Beams](https://github.com/obin1/beam-simulation)"""

# ╔═╡ b3eedbea-4f49-11eb-023d-091b1dc586fb
md"""## Plans ahead"""

# ╔═╡ c40e1f2c-4f49-11eb-1570-6f7abb9fd659
md""" 
- exporting notebooks independent of Julia (currently on Binder)
- notebooks within notebooks [^1] 
- spreadsheets and pluto (DataFrames.jl already implemented)
"""

# ╔═╡ 9f1fc46e-4f4a-11eb-1c34-93de108ca2da
md"""[^1]: [https://www.notion.so/Notebooks-inside-notebooks](https://www.notion.so/Notebooks-inside-notebooks-9e99d381c3014e40b310d4846c764a15)
[2]:[Developer notes](https://github.com/fonsp/Pluto.jl/issues/181)"""

# ╔═╡ 14938c8c-4f4e-11eb-0e73-896408463cd5
md"""## Disclaimer
![a good ol' meme](https://raw.githubusercontent.com/arv-n/banana-talk/master/graphics/meme.jpeg?token=ANRV5FMJ6SHNVLCWHQ7X2ZC76R3C2)
- an add on tool alongside dominant text based editors
- But **MATLAB**, seriously? c'mon! :p """

# ╔═╡ 595cb576-4f4b-11eb-1dce-433bc865b101
md"""# Resources"""

# ╔═╡ 64349752-4f4b-11eb-0303-4933363270ec
md"""
- [Readme](https://juliahub.com/docs/Pluto/OJqMt/0.7.4/)
- [GitHub](https://github.com/fonsp/Pluto.jl/)
- [MIT Course on Computational Thinking with Julia](https://computationalthinking.mit.edu/Fall20/)
- [Binder](https://hub.gke2.mybinder.org/user/fonsp-pluto-on-binder-tt7zur5m/pluto/sample) (for the skeptics!)
"""

# ╔═╡ Cell order:
# ╠═5287cbd6-4f47-11eb-3e96-a70de25fc446
# ╟─f84b8ad4-4c78-11eb-2981-edac56ec8e33
# ╟─5faec94a-4c79-11eb-1024-994c009767f1
# ╟─0d3819d0-4ca6-11eb-3125-29938dcc7854
# ╟─e38ff548-4ca6-11eb-3dd8-630c05d29035
# ╟─ffccd4fe-4ca8-11eb-37cd-9dd5f0caeda5
# ╟─01d7b76e-4cdb-11eb-0668-dd07c0f9e436
# ╟─3058dc6a-4c79-11eb-0dfe-156d42a74ccd
# ╟─ba9a5042-4cd4-11eb-2e74-430975156698
# ╟─66ce5514-4cd7-11eb-3e42-f9a171afd502
# ╟─9d4a2a14-4cd7-11eb-3aa2-0967b982b4e8
# ╟─281011ec-4cd9-11eb-22c9-e3adae18d456
# ╟─de878830-4cd9-11eb-2a3c-5f47c7cbf7bc
# ╟─6f0eecee-4cdb-11eb-36d9-91c896b7617b
# ╟─8bf955f6-4cdb-11eb-0e10-db7dec48150d
# ╟─aeeb976a-4cde-11eb-1596-f3c9360955e1
# ╟─90815c32-4f3f-11eb-3487-f9e114b6a9f9
# ╠═34592828-4f4f-11eb-093e-9d1cdd17beff
# ╠═e9aa3024-4f67-11eb-132b-cb309ec23ff2
# ╠═ee80342e-4f67-11eb-31de-c5192e87f7e6
# ╟─2013a0ea-4f76-11eb-38ab-09c3ed0319f5
# ╟─a00ac636-4f44-11eb-1461-adb11d4c6430
# ╟─3be9dd0e-4f76-11eb-09d4-a1f5d49bbc79
# ╠═aa34d5f2-4f76-11eb-0a46-49123556f056
# ╟─465b35da-4f76-11eb-0f4c-c1abb3adfe6b
# ╟─653e2074-4f45-11eb-254a-b9404b525f35
# ╟─98a9e00e-4f45-11eb-29a6-8760cc83fbe3
# ╟─d0067ec4-4f45-11eb-1daf-1379f4e91db0
# ╠═f44642e4-4f45-11eb-3747-4d1ff8ad3c89
# ╠═88af08ee-4f62-11eb-27b1-9f92a7a3bc76
# ╟─f625f79c-4f45-11eb-1088-2bcc4a295cbd
# ╟─07172b66-4f46-11eb-2ff3-e3c710b8495e
# ╟─1ce7e55c-4f46-11eb-2e23-a31bd56528ba
# ╟─e218adee-4f48-11eb-1a37-4dc87eca40ff
# ╠═341a6378-4f49-11eb-025e-3b9283994151
# ╠═350868a2-4f49-11eb-1814-db8671064552
# ╠═c74db2da-4f62-11eb-3f9b-0f76e1c77d86
# ╟─d5fbac10-4f62-11eb-00b5-9f561d89a04d
# ╟─96254060-4f49-11eb-17a8-b1698e01fbb7
# ╟─88a9054e-4f61-11eb-36e0-a7627efdfc16
# ╟─b3eedbea-4f49-11eb-023d-091b1dc586fb
# ╟─c40e1f2c-4f49-11eb-1570-6f7abb9fd659
# ╟─9f1fc46e-4f4a-11eb-1c34-93de108ca2da
# ╟─14938c8c-4f4e-11eb-0e73-896408463cd5
# ╟─595cb576-4f4b-11eb-1dce-433bc865b101
# ╟─64349752-4f4b-11eb-0303-4933363270ec

### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 43179a7a-0dc3-4987-914b-5f4bbdb0c672
begin
	using ProgressMeter
	using PyCall
	np = pyimport("numpy")
	cel = pyimport("celluloid")
	using PyPlot
end

# ╔═╡ ea404548-ac63-49ba-bb15-e1b4b564c153
md"
# Random Walk "

# ╔═╡ 8902895a-f524-4152-93c6-1c175aeefbd0
md"## Unbiaised random walk"

# ╔═╡ 4df7f63d-8f57-4469-bc04-5b79b3c47ae6
function unbiaisedrw(A,B,vit,h,l)
	v = vit
    r = rand(Float64)*360
	
	A = A + v*cosd(r)
	B = B + v*sind(r)
	
	#boundaries conditions
	if A < 0
		A = 0
	end
	if A > l - abs(v*cosd(r))
		A = l
	end
	if B < 0
		B = 0
	end
	if B > h - abs(v*sind(r))
		B = h
	end
    return [A,B]
end;

# ╔═╡ 2c6e5885-6ad6-412b-8dcb-d98314109d5a
md" ## Biaised random walk"

# ╔═╡ a29b8a42-fe93-11eb-0544-fdfb80f03003
function biaisedrw(A,B,vit,h,l)
	v = vit
    r = rand(Float64)*360
    b = rand(Float64)
	
	A = A + v*cosd(r)
	if b > 0.98
		B = B + v*abs(sind(r))
	else
		B = B + v*sind(r)
	end
	
	# boundaries conditions
	if A < 0
		A = 0
	end
	if A > l - abs(v*cosd(r))
		A = l
	end
	if B < 0
		B = 0
	end
	if B > h - abs(v*sind(r))
		B = h
	end
    return [A,B]
end;

# ╔═╡ e5f498de-785e-45c6-a3d0-10f9d9369b5a
begin
	nbrsim = 8000;
	nbrcell = 20;
	haut = 150.0;
	long = 150.0;
	v = 1;
	
	list1 = [rand(0:0.001:long/3,nbrcell),rand(0:0.001:haut/3,nbrcell)]
	list2 = [rand(0:0.001:long/3,nbrcell),rand(haut/3:0.001:2*haut/3,nbrcell)]
	list3 = [rand(0:0.001:long/3,nbrcell),rand(2*haut/3:0.001:haut,nbrcell)]
	list4 = [rand(long/3:0.001:2*long/3,nbrcell),rand(0:0.001:haut/3,nbrcell)]
	list5 = [rand(long/3:0.001:2*long/3,nbrcell),rand(haut/3:0.001:2*haut/3,nbrcell)]
	list6 = [rand(long/3:0.001:2*long/3,nbrcell),rand(2*haut/3:0.001:haut,nbrcell)]
	list7 = [rand(2*long/3:0.001:long,nbrcell),rand(0:0.001:haut/3,nbrcell)]
	list8 = [rand(2*long/3:0.001:long,nbrcell),rand(haut/3:0.001:2*haut/3,nbrcell)]
	list9 = [rand(2*long/3:0.001:long,nbrcell),rand(2*haut/3:0.001:haut,nbrcell)]
	
	list0 = [[vcat(list1[1],list2[1],list3[1],list4[1],list5[1],list6[1],list7[1],list8[1],list9[1]),vcat(list1[2],list2[2],list3[2],list4[2],list5[2],list6[2],list7[2],list8[2],list9[2])]]
	
	list = list0
	for i = 1:nbrsim
		newlist = [[],[]]
		for i = 1:9*nbrcell
			X = list[end][1][i]
			Y = list[end][2][i]
			
			metro = biaisedrw(X,Y,v,haut,long) # replace by unbiaisedrw for unbiaised 												 random walk
			append!(newlist[1],[metro[1]])
			append!(newlist[2],[metro[2]])
		end
		append!(list,[newlist])
	end
end

# ╔═╡ dcedc848-5219-4614-9781-378defe5496a
md" ## Plot"

# ╔═╡ 13337591-67b3-4cc9-a086-ddcc6be1ed4a
begin
	a = 0.7
	f = 8000
	s = 100
	plt.figure(figsize=(6,6))
	plt.scatter(list[f][1][1:nbrcell],list[f][2][1:nbrcell],s=s,c="#4477AA",alpha = 0.5)
	plt.scatter(list[f][1][nbrcell+1:2*nbrcell],
		list[f][2][nbrcell+1:2*nbrcell],s=s,c="#DEA73A",alpha = a)
	plt.scatter(list[f][1][2*nbrcell+1:3*nbrcell],
		list[f][2][2*nbrcell+1:3*nbrcell],s=s,c="#44AA77",alpha = a)
	plt.scatter(list[f][1][3*nbrcell+1:4*nbrcell],
		list[f][2][3*nbrcell+1:4*nbrcell],s=s,c="#AAAA44",alpha = a)
	plt.scatter(list[f][1][4*nbrcell+1:5*nbrcell],
		list[f][2][4*nbrcell+1:5*nbrcell],s=s,c="gray",alpha = a)
	plt.scatter(list[f][1][5*nbrcell+1:6*nbrcell],
		list[f][2][5*nbrcell+1:6*nbrcell],s=s,c="#DD77AA",alpha = a)
	plt.scatter(list[f][1][6*nbrcell+1:7*nbrcell],
		list[f][2][6*nbrcell+1:7*nbrcell],s=s,c="#781C81",alpha = a)
	plt.scatter(list[f][1][7*nbrcell+1:8*nbrcell],
		list[f][2][7*nbrcell+1:8*nbrcell],s=s,c="#404096",alpha = a)
	plt.scatter(list[f][1][8*nbrcell+1:9*nbrcell],
		list[f][2][8*nbrcell+1:9*nbrcell],s=s,c="#D92120",alpha = a)
	
	plt.tick_params(left=false,
                bottom=false,
                labelleft=false,
                labelbottom=false)
	
	plt.gca().set_aspect("equal")
	plt.draw()
	plt.show()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ProgressMeter = "92933f4c-e287-5a05-a399-4b506db050ca"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"

[compat]
ProgressMeter = "~1.7.1"
PyCall = "~1.92.3"
PyPlot = "~2.9.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Conda]]
deps = ["JSON", "VersionParsing"]
git-tree-sha1 = "299304989a5e6473d985212c28928899c74e9421"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.5.2"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LaTeXStrings]]
git-tree-sha1 = "c7f1c695e06c01b95a67f0cd1d34994f3e7db104"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.2.1"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "0fb723cd8c45858c22169b2e42269e53271a6df7"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.7"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "438d35d2d95ae2c5e8780b330592b6de8494e779"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "169bb8ea6b1b143c5cf57df6d34d022a7b60c6db"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.3"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "67dde2482fe1a72ef62ed93f8c239f947638e5a2"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.9.0"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[VersionParsing]]
git-tree-sha1 = "80229be1f670524750d905f8fc8148e5a8c4537f"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
"""

# ╔═╡ Cell order:
# ╟─ea404548-ac63-49ba-bb15-e1b4b564c153
# ╠═43179a7a-0dc3-4987-914b-5f4bbdb0c672
# ╟─8902895a-f524-4152-93c6-1c175aeefbd0
# ╠═4df7f63d-8f57-4469-bc04-5b79b3c47ae6
# ╟─2c6e5885-6ad6-412b-8dcb-d98314109d5a
# ╠═a29b8a42-fe93-11eb-0544-fdfb80f03003
# ╠═e5f498de-785e-45c6-a3d0-10f9d9369b5a
# ╟─dcedc848-5219-4614-9781-378defe5496a
# ╠═13337591-67b3-4cc9-a086-ddcc6be1ed4a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002

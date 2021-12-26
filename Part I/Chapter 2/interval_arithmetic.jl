### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ b70ee5f2-3c05-11ec-37db-1704f9c112b5
begin
	using ValidatedNumerics
	using StaticArrays
	using DelimitedFiles
	using IntervalArithmetic
	using IntervalRootFinding
	using LinearAlgebra
	using PyCall
	np = pyimport("numpy")
	cel = pyimport("celluloid")
	using PyPlot
end

# ╔═╡ f7a8506d-2e53-4e72-aaa8-b4133a6520cf
md"# Interval arithmetic"

# ╔═╡ 5397e0bd-378c-42fe-a23e-d5eca0b5a010
md"## Self positive feedback loop"

# ╔═╡ 17757d95-5205-4620-b0ad-c6dd844c13cc
begin
	function fself(x,c1,c2)
	    fself1 = c1*x^2/(c2+x^2) - x
	    return fself1
	end
	
	Sself = [];
	Sselfx = [];
	Sselfy = [];
	
	for c1 in 0.1:1:20.0
	    for c2 in 0.1:1:20.0
	        X0 = (0.0..c1)
	        rts = roots(xx -> fself(xx, c1, c2), X0, Krawczyk, 0.000001)
	        nsol = 0
	        for rt in rts
	            if rt.status == :unique
	                nsol += 1
	            end
	        end
	        if nsol >= 2
	            append!(Sself,[[c1,c2]])
	            append!(Sselfx,c1)
	            append!(Sselfy,c2)
	        end
	    
	    end
	end
end

# ╔═╡ c92b4d43-33a1-4ca1-8403-e2900ca6d2be
begin
	tself = np.arange(0.0, 10.0, 0.2)
	uself = tself.^2/4
end;

# ╔═╡ 957a1119-3ffa-4f29-aae6-8d4991e0ebfc
begin
	plt.figure(figsize=(7,7))
	plt.scatter(Sselfx,Sselfy,label = "Bistable configuration",color="#D24D3E",s=25)
	plt.plot(tself,uself,label = "Critical curve",color="#781C81")
	plt.legend()
	plt.gca().set_aspect("equal")
	plt.xlabel("c (a.u.)")
	plt.ylabel("K (a.u.)")
	plt.xlim(0,20)
	plt.ylim(0,20)
	plt.show()
end

# ╔═╡ 64334315-5d05-4032-9ad3-8130d66fe008
md"## Double positive feedback loop"

# ╔═╡ 0b88f3f9-8e5f-479a-9c06-ee0aebfd200e
begin
	function fpos(x,c1,c2)
	    fpos1 = c1*x[2]^2/(1+x[2]^2) - x[1]
	    fpos2 = c2*x[1]^2/(1+x[1]^2) - x[2]
	    return SVector(fpos1, fpos2)
	end
	
	Spos = [];
	Sposx = [];
	Sposy = [];
	
	for c1 in 0.0:0.4:10.0
	    for c2 in 0.0:0.4:10.0
	        
	        X0 = IntervalBox(0.0..c1, 0.0..c2)
	        rts = roots(xx -> fpos(xx, c1, c2), X0, Krawczyk, 0.000001)
	        nsol = 0
	        for rt in rts
	            if rt.status == :unique
	                nsol += 1
	            end
	        end
	        if nsol >= 2
	            append!(Spos,[[c1,c2]])
	            append!(Sposx,c1)
	            append!(Sposy,c2)
	        end
	    
	    end
	end
end

# ╔═╡ 20a1adeb-9286-45d7-8f27-b5a41d6052d9
begin
	tpos = np.arange(0.0, 1.6, 0.01)
	apos = (4 .*tpos) ./(3 .- tpos.^2)
	bpos = (((4 ./(1 .+tpos.^2)).-1).+0im).^ (1/2) .* (1 .+ 1 ./tpos.^2)
end;

# ╔═╡ c0d8791e-190e-4799-9ec9-224fcd7bfcfb
begin
	plt.figure(figsize=(7,7))
	plt.scatter(Sposx,Sposy,label = "Bistable configuration",color="#D24D3E",s=20)
	plt.scatter(0,0,color="#3D52A1",s=50)
	plt.plot(bpos,apos,label = "Critical curve",color="#781C81")
	plt.legend()
	plt.gca().set_aspect("equal")
	plt.xlabel("c (a.u.)")
	plt.ylabel("K (a.u.)")
	plt.xlim(-0.5,10)
	plt.ylim(-0.5,10)
	plt.show()
end

# ╔═╡ 6ee9dd70-2e76-4fb3-8972-14edbe3f4103
md"## Double negative feedback loop"

# ╔═╡ 6218e2ed-902b-4a3c-9f19-8fced206df1c
begin
	function fneg(x,c1,c2)
	    fneg1 = c1/(1+x[2]^2) - x[1]
	    fneg2 = c2/(1+x[1]^2) - x[2]
	    return SVector(fneg1, fneg2)
	end
	
	Sneg = [];
	Snegx = [];
	Snegy = [];
	
	for c1 in 0.1:0.4:10.0
	    for c2 in 0.1:0.4:10.0
	        
	        X0 = IntervalBox(0.0..c1, 0.0..c2)
	        #rts = roots(xx -> f(xx, c1, c2), X0,0.000001)
	        rts = roots(xx -> fneg(xx, c1, c2), X0, Krawczyk, 0.000001)
	        nsol = 0
	        for rt in rts
	            if rt.status == :unique
	                nsol += 1
	            end
	        end
	        if nsol >= 2
	            append!(Sneg,[[c1,c2]])
	            append!(Snegx,c1)
	            append!(Snegy,c2)
	        end
	    
	    end
	end
end

# ╔═╡ f5f2d5b5-effb-46ac-ac23-a10f88f00b46
begin
	tneg = np.arange(0.6, 5.0, 0.01)
	aneg = (4 .*tneg.^3) ./(3 .*tneg.^2 .- 1)
	bneg = ((1 .+ tneg.^2)./(3 .*tneg.^2 .- 1).+0im).^ (1/2) .* (1 .+ tneg.^2)
end;

# ╔═╡ 954f9963-1249-43b4-800e-6d46604a27b0
begin
	plt.figure(figsize=(7,7))
	plt.scatter(Snegx,Snegy,label = "Bistable configuration",color="#D24D3E",s=20)
	plt.scatter(0,0,color="#3D52A1",s=50)
	plt.plot(aneg,bneg,label = "Critical curve",color="#781C81")
	plt.legend()
	plt.gca().set_aspect("equal")
	plt.xlabel("c (a.u.)")
	plt.ylabel("K (a.u.)")
	plt.xlim(-0.5,10)
	plt.ylim(-0.5,10)
	plt.show()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DelimitedFiles = "8bb1440f-4735-579b-a4ab-409b98df4dab"
IntervalArithmetic = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
IntervalRootFinding = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
ValidatedNumerics = "d621b6e3-7715-5857-9c6f-c67000ef6083"

[compat]
IntervalArithmetic = "~0.17.8"
IntervalRootFinding = "~0.5.7"
PyCall = "~1.92.5"
PyPlot = "~2.10.0"
StaticArrays = "~1.2.13"
ValidatedNumerics = "~0.11.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CRlibm]]
deps = ["Libdl"]
git-tree-sha1 = "9d1c22cff9c04207f336b8e64840d0bd40d86e0e"
uuid = "96374032-68de-5a5b-8d9e-752f78720389"
version = "0.8.0"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "3533f5a691e60601fe60c90d8bc47a27aa2907ec"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.0"

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

[[CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[DiffRules]]
deps = ["NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "7220bc21c33e990c14f4a9a319b1d242ebc5b269"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.3.1"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[ErrorfreeArithmetic]]
git-tree-sha1 = "d6863c556f1142a061532e79f611aa46be201686"
uuid = "90fa49ef-747e-5e6f-a989-263ba693cf1a"
version = "0.5.2"

[[ExprTools]]
git-tree-sha1 = "b7e3d17636b348f005f11040025ae8c6f645fe92"
uuid = "e2ba6199-217a-4e67-a87a-7c52f15ade04"
version = "0.1.6"

[[FastRounding]]
deps = ["ErrorfreeArithmetic", "Test"]
git-tree-sha1 = "224175e213fd4fe112db3eea05d66b308dc2bf6b"
uuid = "fa42c844-2597-5d31-933b-ebd51ab2693f"
version = "0.2.0"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "63777916efbcb0ab6173d09a658fb7f2783de485"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.21"

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "19cb49649f8c41de7fea32d089d37de917b553da"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.0.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IntervalArithmetic]]
deps = ["CRlibm", "FastRounding", "LinearAlgebra", "Markdown", "Random", "RecipesBase", "RoundingEmulator", "SetRounding", "StaticArrays"]
git-tree-sha1 = "00cce14aeb4b256f2f57caf3f3b9354c27d93259"
uuid = "d1acc4aa-44c8-5952-acd4-ba5d80a2a253"
version = "0.17.8"

[[IntervalConstraintProgramming]]
deps = ["IntervalArithmetic", "IntervalContractors", "IntervalRootFinding", "MacroTools", "Test"]
git-tree-sha1 = "e5234b7d91eaaa80305cd8e74a5f2231d4d0e05e"
uuid = "138f1668-1576-5ad7-91b9-7425abbf3153"
version = "0.9.1"

[[IntervalContractors]]
deps = ["IntervalArithmetic"]
git-tree-sha1 = "02e049c761e7fd911566c6b0eff9deffe7de876b"
uuid = "15111844-de3b-5229-b4ba-526f2f385dc9"
version = "0.4.5"

[[IntervalOptimisation]]
deps = ["IntervalArithmetic"]
git-tree-sha1 = "7928f5018b5f54adb6780a43b975880633ead850"
uuid = "c7c68f13-a4a2-5b9a-b424-07d005f8d9d2"
version = "0.4.5"

[[IntervalRootFinding]]
deps = ["ForwardDiff", "IntervalArithmetic", "LinearAlgebra", "Polynomials", "StaticArrays"]
git-tree-sha1 = "2b3c1cbe892ceb2f3936fd734c1c98ea97dfb18e"
uuid = "d2bf35a9-74e0-55ec-b149-d360ff49b807"
version = "0.5.7"

[[Intervals]]
deps = ["Dates", "Printf", "RecipesBase", "Serialization", "TimeZones"]
git-tree-sha1 = "323a38ed1952d30586d0fe03412cde9399d3618b"
uuid = "d8418881-c3e1-53bb-8760-2df7ec849ed5"
version = "1.5.0"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "f0c6489b12d28fb4c2103073ec7452f3423bd308"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.1"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "6193c3815f13ba1b78a51ce391db8be016ae9214"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.4"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Mocking]]
deps = ["Compat", "ExprTools"]
git-tree-sha1 = "29714d0a7a8083bba8427a4fbfb00a540c681ce7"
uuid = "78c3b35d-d492-501b-9361-3d52fe80e533"
version = "0.7.3"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "8d9496b2339095901106961f44718920732616bb"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "0.2.22"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "d911b6a12ba974dabe2291c6d450094a7226b372"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.1"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[Polynomials]]
deps = ["Intervals", "LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "7499556d31417baeabaa55d266a449ffe4ec5a3e"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "2.0.17"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "4ba3651d33ef76e24fef6a598b63ffd1c5e1cd17"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.92.5"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
git-tree-sha1 = "44a75aa7a527910ee3d1751d1f0e4148698add9e"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.1.2"

[[Reexport]]
deps = ["Pkg"]
git-tree-sha1 = "7b1d07f411bc8ddb7977ec7f377b97b158514fe0"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "0.2.0"

[[RoundingEmulator]]
git-tree-sha1 = "40b9edad2e5287e05bd413a38f61a8ff55b9557b"
uuid = "5eaf0fd0-dfba-4ccb-bf02-d820a40db705"
version = "0.2.1"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SetRounding]]
git-tree-sha1 = "d7a25e439d07a17b7cdf97eecee504c50fedf5f6"
uuid = "3cc68bcd-71a2-5612-b932-767ffbe40ab0"
version = "0.2.1"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TimeZones]]
deps = ["Dates", "Downloads", "InlineStrings", "LazyArtifacts", "Mocking", "Pkg", "Printf", "RecipesBase", "Serialization", "Unicode"]
git-tree-sha1 = "8de32288505b7db196f36d27d7236464ef50dba1"
uuid = "f269a46b-ccf7-5d73-abea-4c690281aa53"
version = "1.6.2"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[ValidatedNumerics]]
deps = ["IntervalArithmetic", "IntervalConstraintProgramming", "IntervalContractors", "IntervalOptimisation", "IntervalRootFinding", "Reexport", "Test"]
git-tree-sha1 = "3e913fa00b3943675ac8ddd4121adeb1754e99f9"
uuid = "d621b6e3-7715-5857-9c6f-c67000ef6083"
version = "0.11.0"

[[VersionParsing]]
git-tree-sha1 = "e575cf85535c7c3292b4d89d89cc29e8c3098e47"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.2.1"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─f7a8506d-2e53-4e72-aaa8-b4133a6520cf
# ╠═b70ee5f2-3c05-11ec-37db-1704f9c112b5
# ╟─5397e0bd-378c-42fe-a23e-d5eca0b5a010
# ╠═17757d95-5205-4620-b0ad-c6dd844c13cc
# ╠═c92b4d43-33a1-4ca1-8403-e2900ca6d2be
# ╠═957a1119-3ffa-4f29-aae6-8d4991e0ebfc
# ╟─64334315-5d05-4032-9ad3-8130d66fe008
# ╠═0b88f3f9-8e5f-479a-9c06-ee0aebfd200e
# ╠═20a1adeb-9286-45d7-8f27-b5a41d6052d9
# ╠═c0d8791e-190e-4799-9ec9-224fcd7bfcfb
# ╟─6ee9dd70-2e76-4fb3-8972-14edbe3f4103
# ╠═6218e2ed-902b-4a3c-9f19-8fced206df1c
# ╠═f5f2d5b5-effb-46ac-ac23-a10f88f00b46
# ╠═954f9963-1249-43b4-800e-6d46604a27b0
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002

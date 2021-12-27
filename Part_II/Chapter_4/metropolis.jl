### A Pluto.jl notebook ###
# v0.17.3

using Markdown
using InteractiveUtils

# ╔═╡ 48b0d87e-6d87-4ea4-8ff2-8a0bd1622e06
begin
	using PyCall
	using PyPlot
end

# ╔═╡ f71a4046-2d1e-43eb-ab58-9abfb71838bd
md"
# Simulation of bacterial chemotaxis using the Metropolis algorithm"

# ╔═╡ 92d70ea7-a645-4b86-8b52-13c0d7e8cebf
md"## Gradient concentration"

# ╔═╡ cad72d1c-fe96-11eb-31d4-bb1ecc023f48
begin
	g_00(x) = 0;
	g_0001(x) = -0.0006/(0.715*exp(-0.0056*x)+0.684)+0.00093;
	g_001(x) = -0.009/(1.027*exp(-0.005*x)+1)+0.0095;   ## concentration = 0.01 ##
	g_01(x) = -0.09/(1.34*exp(-0.005*x)+1.04)+0.092;     ## concentration = 0.1 ##
	g_1(x) = -0.9/(1.5*exp(-0.0054*x)+1.03)+0.9;    ## concentration = 1 ##
end;

# ╔═╡ b2f71336-c09d-4ef4-81a4-baf5844ae1aa
md"## Metropolis algorithm"

# ╔═╡ 4c445682-10be-4ed6-b4a4-5da9a02bdd99
function metropolis(A,B,g,vit,c_dis,x0,beta,h,c)
    l = vit
    r = rand(0:360)
    r_metr = rand()
    r_rej = rand()
	## function H ##
    k = 1
    a = 0.5;
    
    Hx = -2*(0.03*c/(c+0.03)^2)^a*(g(B)/c)
    Hy = -2*(0.03*c/(c+0.03)^2)^a*(g(B+l*sind(r))/c)
    
    m = (g(0)+g(600))/2
	## metropolis algorithm ##
    if sind(r)<=0
        if B <= -l*sind(r)
            B = 0
        else
            B = B + l*sind(r)
        end
        if A + l*cosd(r) <= 0
                A = 0
        elseif A + l*cosd(r) >= 10
                A = 10
        else
            A = A + l*cosd(r)
        end
    else
         if exp((-beta)*x0*(Hy-Hx)) >= r_metr
            if B >= h - l*sind(r)
                B = h
            else
                B = B + l*sind(r) 
            end
            if A + l*cosd(r) <= 0
                A = 0
            elseif A + l*cosd(r) >= 10
                A = 10
            else
                A = A + l*cosd(r)
            end
        else
            if r_rej >= 1/2
                A = A 
                B = B
            else
                A = A 
                B = B
            end
        end
    end
    return [A,B]
end;

# ╔═╡ 80a0102d-4845-4a6f-bd98-7dd48df95665
md"## Simulation"

# ╔═╡ 80a80780-d053-4a60-be57-6d51661b7aa0
begin
	time = 1000;
	nbr_cell = 400;
	nbr_sim = 1;
	
	haut = 100.0;
	long = 100.0;
	v = 15;
	
	x0 = 300000;
	c_dis = 30;
	
	b_001 = 0.000013;
	b_01  = 0.000013;
	b_1   = 0.000013;
	
	k_001 = 2;
	k_01 = 2;
	k_1 = 2;
	
	t_001 = 0.5;
	t_01 = 0.5;
	t_1 = 0.5;
	
	
	c_001 = 0.00236;
	c_01 = 0.0268;
	c_1 = 0.279;
	
	c_c = -0.000009
end;

# ╔═╡ a43b128a-9c98-46bc-82f1-20fa7ac04951
begin
	res01 = [] 
	list01 = [[rand(0:0.0001:0.01,nbr_cell),rand(24.9:0.01:25.1,nbr_cell)]]
	for t in 1:time
		beta01 = b_01/(1+0.1*exp(-k_01*(t/50-t_01)))
		new_list01 = [[],[]]
		for i in 1:nbr_cell
			A_01 = list01[end][1][i]
			B_01 = list01[end][2][i];
	        metro01 = metropolis(A_01,B_01,g_00,v,c_dis,x0,beta01,haut,c_01);
	        new_list01[1]=append!(new_list01[1],[metro01[1]]);
	        new_list01[2]=append!(new_list01[2],[metro01[2]]);
		end
		append!(list01,[new_list01])
	end
	append!(res01,list01)
end;

# ╔═╡ 212fe946-ee00-44c4-8139-d07afcfba191
md"## Plot"

# ╔═╡ f8df5757-9f83-4555-b637-409af08b3a11
begin
	plt.scatter(res01[5][1],res01[5][2],s=5,color="green",zorder=9)
	plt.gca().set_aspect("equal")
	plt.draw()
	plt.show()
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PyCall = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"

[compat]
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
git-tree-sha1 = "477bf42b4d1496b454c10cce46645bb5b8a0cf2c"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

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
# ╟─f71a4046-2d1e-43eb-ab58-9abfb71838bd
# ╠═48b0d87e-6d87-4ea4-8ff2-8a0bd1622e06
# ╟─92d70ea7-a645-4b86-8b52-13c0d7e8cebf
# ╠═cad72d1c-fe96-11eb-31d4-bb1ecc023f48
# ╟─b2f71336-c09d-4ef4-81a4-baf5844ae1aa
# ╠═4c445682-10be-4ed6-b4a4-5da9a02bdd99
# ╟─80a0102d-4845-4a6f-bd98-7dd48df95665
# ╠═80a80780-d053-4a60-be57-6d51661b7aa0
# ╠═a43b128a-9c98-46bc-82f1-20fa7ac04951
# ╟─212fe946-ee00-44c4-8139-d07afcfba191
# ╠═f8df5757-9f83-4555-b637-409af08b3a11
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002

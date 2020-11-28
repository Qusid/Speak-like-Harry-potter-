using Distances, Statistics
using MultivariateStats
using PyPlot
using WordTokenizers
using TextAnalysis
using DelimitedFiles

function load_embeddings(embedding_file)
    local LL, indexed_words, index
    indexed_words = Vector{String}()
    LL = Vector{Vector{Float32}}()
    open(embedding_file) do f
        index = 1
        for line in eachline(f)
            xs = split(line)
            word = xs[1]
            push!(indexed_words, word)
            push!(LL, parse.(Float32, xs[2:end]))
            index += 1
        end
    end
    return reduce(hcat, LL), indexed_words
end

embeddings, vocab = load_embeddings("glove.6B.50d.txt")
vec_size, vocab_size = size(embeddings)
println("Loaded embeddings, each word is represented by a vector with $vec_size features. The vocab size is $vocab_size")

vec_idx(s) = findfirst(x -> x==s, vocab)
vec_idx("cheese")

function vec(s) 
    if vec_idx(s)!=nothing
        embeddings[:, vec_idx(s)]
    end    
end
vec("cheese")

function closest(v, n=20)
    list=[(x,cosine(embeddings'[x,:], v)) for x in 1:size(embeddings)[2]]
    topn_idx=sort(list, by = x -> x[2], rev=true)[1:n]
    return [vocab[a] for (a,_) in topn_idx]
end

cosine(x,y)=1-cosine_dist(x, y)

txt = open("harrynew.txt") do file
    read(file, String)
end


println("Loaded Harry potter, length=$(length(txt)) characters")

txt = replace(txt, r"\n|\r|_|," => " ")
txt = replace(txt, r"[\"*();!]" => "")
sd=StringDocument(txt)
prepare!(sd, strip_whitespace)
sentences = split_sentences(sd.text)
i=1
for s in 1:length(sentences)
    if length(split(sentences[s]))>3
        sentences[i]=lowercase(replace(sentences[s], "."=>""))
        i+=1
    end
end
sentences[1000:1010]

function sentvec(s) 
    local arr=[]
    for w in split(sentences[s])
        if vec(w)!=nothing
            push!(arr, vec(w))
        end
    end
    if length(arr)==0
        ones(Float32, (50,1))*999
    else
        mean(arr)
    end
end

sentvec(100)





#= drac_sent_vecs=[]
for s in 1:length(sentences)
    i==1 ? drac_sent_vecs=sentvec(s) : push!(drac_sent_vecs,sentvec(s))
end
writedlm( "drac_sent_vec.csv",  drac_sent_vecs, ',')
writedlm( "drac_sentences.csv",  sentences, ',')
=#
sentences=readdlm("drac_sentences.csv", '!', String, header=false)
drac_sent_vecs=readdlm("drac_sent_vec.csv", ',', Float32, header=false)
function closest_sent_pretrained(pretrained_arr, input_str, n=20)
    mean_vec_input=mean([vec(w) for w in split(input_str)])
    list=[(x,cosine(mean_vec_input, pretrained_arr[x,:])) for x in 1:length(sentences)]
    topn_idx=sort(list, by = x -> x[2], rev=true)[1:n]
    return [sentences[a] for (a,_) in topn_idx]
end

closest_sent_pretrained(drac_sent_vecs, "i love this class") #write your sentence here 



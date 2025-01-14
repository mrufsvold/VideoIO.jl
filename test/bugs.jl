@testset "c api memory leak test" begin
    if (Sys.islinux())
        function get_memory_usage()
            open("/proc/$(getpid())/statm") do io
                return split(read(io, String))[1]
            end
        end

        file = joinpath(videodir, "annie_oakley.ogg")

        @testset "open file test" begin
            check_size = 10
            usage_vec = Vector{String}(undef, check_size)

            for i in 1:check_size
                f = VideoIO.openvideo(file)
                close(f)
                GC.gc()

                usage_vec[i] = get_memory_usage()
            end

            println(usage_vec)

            @test usage_vec[end-1] == usage_vec[end]
        end

        @testset "open and read file test" begin
            check_size = 10
            usage_vec = Vector{String}(undef, check_size)

            for i in 1:check_size
                f = VideoIO.openvideo(file)
                img = read(f)
                close(f)
                GC.gc()

                usage_vec[i] = get_memory_usage()
            end

            println(usage_vec)

            @test usage_vec[end-1] == usage_vec[end]
        end
    end
end

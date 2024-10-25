function textgen
    function main
        # locking mechanism to prevent multiple instances
        flock -x -n 200 || exit 1

        # define launch options here
        set -l options (fish_opt -s 1 -l web )
        set options $options (fish_opt -s 2 -l api)
        set options $options (fish_opt -s 3 -l chat)
        set options $options (fish_opt -s 4 -l code)
        argparse $options -- $argv

        # map launch options to their respective textgen launch configurations
        set -l textgenargs --model-dir /media/cachedisk-01/ml-models/text-generation-models --listen
        if set -q _flag_web
            set textgenargs $textgenargs --extensions gallery
        end

        if set -q _flag_api
            set textgenargs $textgenargs --extensions gallery --api
        end

        if set -q _flag_chat
            set textgenargs $textgenargs --extensions gallery --model bartowski_Starling-LM-7B-alpha-exl2_8_0
        end

        if set -q _flag_code
            set textgenargs $textgenargs --api --model bartowski_deepseek-coder-7b-instruct-v1.5-exl2_6_5
        end

        #main program wrapper
        set -xa ROCM_PATH '/opt/rocm'
        set -xa HSA_OVERRIDE_GFX_VERSION 10.3.0
        set -xa HCC_AMDGPU_TARGET gfx1030
        set -xa PYTORCH_ROCM_ARCH gfx1030
        set -xa environment True
        # expose only the gpu
        set -xa HIP_VISIBLE_DEVICES 0

        trap cleanup SIGINT SIGTERM
        echo "textgen server wrapper..."

        cd /home/rico/Desktop/ml-projects/text-generation-webui/
        source env/bin/activate.fish

        python server.py --idle-timeout 15 $textgenargs $argv

    end

    main 200>/tmp/textgen-server.lock
end


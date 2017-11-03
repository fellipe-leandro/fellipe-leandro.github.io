cmd_Release/opencv.node := ln -f "Release/obj.target/opencv.node" "Release/opencv.node" 2>/dev/null || (rm -rf "Release/opencv.node" && cp -af "Release/obj.target/opencv.node" "Release/opencv.node")

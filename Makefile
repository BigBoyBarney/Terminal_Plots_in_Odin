all: example all_examples scatter_example plot_example histograms_example \
     house_example color_example olympic_rings_example ellipse_example \
     canvas_example custom_ticks_example logo_example markers_and_labels_example \
     network_example performance_example scatter_cats_example side_by_side_example \
     wetterdienst_example all_examples
	echo "...finished!"

example:
	odin build ./examples/example.odin -file -out:./example.exe -o:speed

all_examples:
	odin build ./examples/all_examples.odin -file -out:./all_example.exe -o:speed

scatter_example:
	odin build ./examples/scatter_example.odin -file -out:./scatter_example.exe -o:speed

plot_example:
	odin build ./examples/plot_example.odin -file -out:./plot_example.exe -o:speed

histograms_example:
	odin build ./examples/histograms_example.odin -file -out:./histograms_example.exe -o:speed
	
house_example:
	odin build ./examples/house_example.odin -file -out:./house_example.exe -o:speed

color_example:
	odin build ./examples/color_example.odin -file -out:./color_example.exe -o:speed
	
olympic_rings_example:
	odin build ./examples/olympic_rings_example.odin -file -out:./olympic_rings_example.exe -o:speed
	
ellipse_example:
	odin build ./examples/ellipse_example.odin -file -out:./ellipse_example.exe -o:speed

canvas_example:
	odin build ./examples/canvas_example.odin -file -out:./canvas_example.exe -o:speed

custom_ticks_example:
	odin build ./examples/custom_ticks_example.odin -file -out:./custom_ticks_example.exe -o:speed

logo_example:
	odin build ./examples/logo_example.odin -file -out:./logo_example.exe -o:speed

markers_and_labels_example:
	odin build ./examples/markers_and_labels_example.odin -file -out:./markers_and_labels_example.exe -o:speed
	
network_example:
	odin build ./examples/network_example.odin -file -out:./network_example.exe -o:speed

performance_example:
	odin build ./examples/performance_example.odin -file -out:./performance_example.exe -o:speed

scatter_cats_example:
	odin build ./examples/scatter_cats_example.odin -file -out:./scatter_cats_example.exe -o:speed

side_by_side_example:
	odin build ./examples/side_by_side_example.odin -file -out:./side_by_side_example.exe -o:speed

wetterdienst_example:
	odin build ./examples/wetterdienst_example.odin -file -out:./wetterdienst_example.exe -o:speed

	
clean:
	rm -f example.exe \
          all_example.exe \
          scatter_example.exe \
          plot_example.exe \
          histograms_example.exe \
          house_example.exe \
          color_example.exe \
          olympic_rings_example.exe \
          ellipse_example.exe \
          canvas_example.exe \
          custom_ticks_example.exe \
          logo_example.exe \
          markers_and_labels_example.exe \
          network_example.exe \
          performance_example.exe \
          scatter_cats_example.exe \
          side_by_side_example.exe \
          wetterdienst_example.exe \

      
run:
	./example.exe
	./all_example.exe
	./scatter_example.exe
	./plot_example.exe
	./histograms_example.exe
	./house_example.exe
	./color_example.exe
	./olympic_rings_example.exe
	./ellipse_example.exe
	./canvas_example.exe
	./custom_ticks_example.exe
	./logo_example.exe
	./markers_and_labels_example.exe
	./network_example.exe
	./performance_example.exe
	./scatter_cats_example.exe
	./side_by_side_example.exe
	./wetterdienst_example.exe

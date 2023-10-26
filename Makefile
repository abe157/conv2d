
OCV_F += `pkg-config --cflags opencv4`
OCV_L += `pkg-config --libs opencv4`

NVCC=/usr/local/cuda/bin/nvcc
ARCH=-arch=sm_86
NVCC_FLAGS=-O3
NVCC_LIB=-lcufft -lcudnn
NVCC_INC=-I./src/ -I/usr/local/cuda/include/ -I/usr/include/opencv4/ 
NVCC_LD=-L/usr/local/cuda/lib64/ -L/usr/include/opencv4/ # -L/usr/local/lib
NVCC_MAKE_FLAGS=$(NVCC_FLAGS) $(ARCH) $(NVCC_LD) $(NVCC_LIB) $(NVCC_INC)

TARGET=conv2d_default conv2d_tensor

all:$(TARGET)

conv2d_default: conv2d_0.o
	$(NVCC) $(NVCC_MAKE_FLAGS) $^ $(OCV_L) -o $@

conv2d_tensor: conv2d_1.o
	$(NVCC) $(NVCC_MAKE_FLAGS) $^ $(OCV_L) -o $@

conv2d_%.o: conv2d.cu
	$(NVCC) $(NVCC_MAKE_FLAGS) $(OCV_F) -DMODE=$* -dc $< -o $@ 

# conv2d: conv2d.o
# 	$(NVCC) $(NVCC_MAKE_FLAGS) $^ $(OCV_L) -o $@

%.o: %.cu
	$(NVCC) $(NVCC_MAKE_FLAGS) $(OCV_F) -dc $< -o $@ 





clean:
	rm -rf $(TARGET) ./*.o



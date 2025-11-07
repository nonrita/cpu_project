# ======================================================
# Verilog Project Makefile
# 使い方:
#   make tb=tb_not
#   make tb=tb_and
# ======================================================

# ソースファイルを自動で集める
SRC := $(wildcard src/gates/*.v)

# テストベンチ（コマンドラインで指定、デフォルトは tb_not）
TB  ?= tb_not
TB_PATH := sim/tb_gates/$(TB).v

# 出力ファイル名
OUT := build/$(TB).out

# 波形フォルダ（自動作成）
WAVE_DIR := sim/waveforms
$(shell mkdir -p $(WAVE_DIR) build)

# iverilogとvvpを使ってビルド & 実行
all:
	@echo "🔧 Building $(TB)..."
	iverilog -o $(OUT) $(SRC) $(TB_PATH)
	@echo "🚀 Running simulation..."
	vvp $(OUT)

# 掃除コマンド
clean:
	rm -f build/*.out

# ======================================================
# Verilog Project Makefile
# 使い方:
#   make tb=tb_not
#   make tb=tb_and
# ======================================================

# src 以下の全ての Verilog ファイルを集める
SRC := $(wildcard src/**/*.v)  # src 以下のサブフォルダも含む

# テストベンチ（コマンドラインで指定、デフォルトは tb_not）
TB  ?= tb_not

# テストベンチフォルダ自動判定
# tb_not が gates, alu, flipflops などに属する場合に自動で選択
TB_DIR := $(shell find sim -type f -name "$(TB).v" -exec dirname {} \;)
TB_PATH := $(TB_DIR)/$(TB).v

# 出力ファイル名
OUT := build/$(TB).out

# 波形フォルダ（自動作成）
WAVE_DIR := sim/waveforms
$(shell mkdir -p $(WAVE_DIR) build)

# ビルド & 実行
all:
	@echo "🔧 Building $(TB)..."
	@echo "SRC files: $(SRC)"
	@echo "TB file: $(TB_PATH)"
	iverilog -o $(OUT) $(SRC) $(TB_PATH)
	@echo "🚀 Running simulation..."
	vvp $(OUT)

# 掃除コマンド
clean:
	rm -f build/*.out

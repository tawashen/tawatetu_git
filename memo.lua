-- メモファイルのパス
local MEMO_FILE = "path_memo.lua"

-- メモデータの読み込み
local function load_memo()
    local memo = {}
    if io.open(MEMO_FILE, "r") then
        memo = dofile(MEMO_FILE) -- ファイルをLuaテーブルとして実行
    end
    return memo or {}
end

-- メモデータの保存
local function save_memo(memo)
    local file = io.open(MEMO_FILE, "w")
    file:write("return {\n")
    for k, v in pairs(memo) do
        file:write(string.format("  [%q] = %d,\n", k, v))
    end
    file:write("}\n")
    file:close()
end

-- 使用例
local memo = load_memo()

-- キー生成（例：index_target）
local key = string.format("%d_%d", 43, 7)

-- 検索時にチェック
if memo[key] then
    print("メモから取得:", memo[key])
else
    -- 通常処理
    local count = 5 -- 計算結果
    memo[key] = count
    save_memo(memo)
end




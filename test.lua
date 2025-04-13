map = {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,6,6,0,0,0,0,0,0,0,0,0,0,7,6,7,0,0,0,0,
    0,6,2,8,5,8,4,8,3,8,4,8,5,8,2,6,0,0,0,0,
    0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,6,0,0,0,0,
    0,0,5,0,0,0,0,0,4,0,0,0,0,0,3,0,0,0,0,0,
    0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,
    0,0,3,0,0,0,0,0,3,0,0,0,0,0,4,0,0,0,0,0,
    0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,
    0,0,4,0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,0,
    0,7,1,7,0,0,0,7,1,7,0,0,0,0,1,0,0,0,0,0,
    0,7,2,8,3,8,5,8,2,8,4,8,3,8,2,6,0,0,0,0,
    0,7,7,7,0,0,0,6,7,6,0,0,0,0,6,6,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  }


--メモライズ関係---

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


function find_min(t)
    local result = 1000000
    for _, num in pairs(t) do
        if result > num then
        result = num
        end
    end
        return result
end

DIRECT = {-20, 1, 20, -1}
 -- 1 or 8 raoad
function nextTree(index) --tree作成
    local new_index = {}
    for _, direc in ipairs(DIRECT) do
    if map[index + direc] == 1 or map[index + direc] == 8 then
        table.insert(new_index, index + direc * 2) --道を挟んだパネルの座標を追加
        end
    end
    return new_index
end

--isStation(43)


function tableToString(t)
    local result = "{"
    for k, v in pairs(t) do
        result = result..tostring(k).."="..tostring(v)..", "
    end
    return result:sub(1, -3).."}"  -- 最後のカンマを削除
end


function containsT(t, num)
    for _, num1 in ipairs(t) do
            if num1 == num then
                return true
            end
        end
    return false
end



 


function nextStation(index, target, from_table, count) --> number（最短距離）

local result = {}
local final = nil
local memo = load_memo()

local key = string.format("%d_%d", index, target)

if memo[key] then
    final = memo[key]
else
    local function saiki(indexS, from_tableS, countS)
        local old_target = nextTree(indexS)
        local new_target = {}
    for _, targ in pairs(old_target) do --New_targetに履歴にあるコマ以外を追加する
        if not containsT(from_tableS, targ) then
            --print(targ)
            table.insert(new_target, targ)
        end
    end
    for _, nextS in ipairs(new_target) do
        if nextS == target then
            new_count = countS + 1
            print(new_count)
            table.insert(result, new_count)
        else 
            print(nextS)
            new_from_table = from_tableS
            table.insert(new_from_table, indexS)
            new_count = countS + 1
            saiki(nextS, new_from_table, new_count)
        end
    end
  end
    saiki(index, from_table, count)
    final = find_min(result)
    memo[key] = final
    save_memo(memo)
end
    return final --数値のみを返す
end




function main ()




nextStation(43, 55, {}, 0)
print(final)
--print(find_min(result))
end

main()
--print(tableToString(isStation(43)))

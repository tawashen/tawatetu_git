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

DIRECT = {-20, 1, 20, -1}
 -- 1 or 8 raoad
function isStation(index) --tree作成
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

 result = {}

function nextStation(index, target, from_table, count)
    --local result = {}

    local function saiki(indexS, from_tableS, countS)
        local old_target = isStation(indexS)
        print("from")
        print(tableToString(from_tableS))
        print("old_target")
        print(tableToString(old_target))
        local new_target = {}
    for _, targ in pairs(old_target) do --New_targetに履歴にあるコマ以外を追加する
        if not containsT(from_tableS, targ) then
            --print(targ)
            table.insert(new_target, targ)
        end
    end
               print("new_target")
            print(tableToString(new_target))
    --if new_target == {} then 
      --  return true
    --else
    for _, nextS in ipairs(new_target) do
        if nextS == target then
            new_count = countS + 1
            table.insert(result, new_count)
            --break
        else 
            print(nextS)
            new_from_table = from_tableS
            table.insert(new_from_table, indexS)
            new_count = countS + 1
            saiki(nextS, new_from_table, new_count)
        end
    end
end
--end
    saiki(index, from_table, count)
end

function main ()
nextStation(43, 55, {}, 0)
print("result")
print(tableToString(result))
end

main()
--print(tableToString(isStation(43)))

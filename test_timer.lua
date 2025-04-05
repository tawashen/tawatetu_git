local Timer = {}

local active_timers = {}

function Timer.update(dt)
    for i = #active_timers, 1, -1 do --Timerをカウントダウンして繰り返し、複数のタイマーを管理
        local timer = active_timers[i]--Timersの要素をtimerに
        if not timer.active then --TimerがActiveで無かったら削除、ガベコレ
            table.remove(active_timers, i)
        else　--timerがActiveなら
            timer.elapsed = timer.elapsed + dt --経過時間にdtを追加
            if timer.elapsed >= timer.interval then --インターバルを超えたら
                timer.elapsed = 0--経過時間リセット
                timer.count = timer.count + 1--繰り返し数に１足す
                
                -- コールバック実行
                --Timer構造体のCallback関数にCountを渡す
                local should_continue = timer.callback(timer.count)              
                if should_continue == false then　
                    timer:stop()　--
                end
                
                -- 繰り返し回数チェック
                if timer.count >= timer.repeats then
                    timer:stop()
                end
            end
        end
    end
end



--Active_timersにtimer構造体を入れる関数
function Timer.every(interval, callback, repeats)
    local timer = {
        interval = interval,
        callback = callback,
        repeats = repeats or math.huge, -- デフォルト無限
        elapsed = 0,
        count = 0,
        active = true
    }
    
    -- タイマー制御用メソッド
    function timer:stop()　--:メソッドなのでtimer.stop(timer)
        self.active = false --timer.active = false
    end

    --Active_timersにTimer構造体を追加
    table.insert(active_timers, timer)
    return timer
end


function Timer.getActiveCount()
    local count = 0
    for _, timer in ipairs(active_timers) do
        if timer.active then count = count + 1 end
    end
    return count  -- 数値を返す
end

return Timer

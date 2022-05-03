class IC_GemFarm_Functions
{
    __new()
    {
        ;1000 ms per sec, 60 sec per min, 60 min per hour, reload script every 12 hours
        ;reloading helps keep key inputs more reliable and faster
        this.ReloadTime := ( 1000 * 60 * 60 * 12 ) + A_TickCount
    }

    GemFarm()
    {
        loop
        {
            ;to be nested in another function, not sure where yet
            if (this.ReloadTime < A_TickCount)
                Reload
        }
    }
}
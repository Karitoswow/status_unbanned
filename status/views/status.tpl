<table class="nice_table" class="h4 text-center">
    <thead>
    <tr>
        <th scope="col" colspan="6" class="h4 text-center">
            Account
        </th>
    </tr>
    </thead>
    <tr>
        <td  style="text-align: center;">
            {if $status == 'Active'}
                <div id="green">
                    {$this->user->getUsername()}  {$status}
                    <div class="clear"></div>
                    <a href="{$url}ucp/">
                        {lang("view", "status")}
                    </a>
                </div>
            {else}
                <div id="red">
                    {$this->user->getUsername()} {$status}
                    <div class="clear"></div>
                    <a href="{$url}status/account" >
                        {lang("view", "status")}
                    </a>
                </div>
            {/if}
        </td>
    </tr>
</table>

<table class="nice_table">
    <thead>
    <th scope="col" colspan="6" class="h4 text-center">
        Realm(s)
    </th>
    </thead>
</table>
<table class="nice_table">
    <tr>
        {foreach from=$realms item=realm}
            <td class="td">
                <div  class="characters" >
                    {$realm->getName()}
                </div>
                {if preg_match("/cmangos/i", get_class($this->realms->getEmulator())) || preg_match("/vmangos/i", get_class($this->realms->getEmulator())) }
                    Disbaled
                {else}
                    {if {$this->totalBannedCharacters($realm->getId())} != 0}

                        <div id="red">
                            {lang("banned_found", "status")} ({$this->totalBannedCharacters($realm->getId())})
                            <div class="clear"></div>
                            <a href="{$url}status/characters/{$realm->getId()}" >
                                {lang("view", "status")}
                            </a>
                        </div>
                    {else}
                        <div id="green">
                            {lang("no_found", "status")}
                            <div class="clear"></div>
                            <a href="{$url}ucp/" >
                                {lang("view", "status")}
                            </a>
                        </div>

                    {/if}
                {/if}
            </td>
        {/foreach}
    </tr>
</table>
<script type="text/javascript">
    $(document).ready(function()
    {
        function initializeBanned()
        {
            if(typeof Status != "undefined")
            {
                Status.User.initialize({$dp});
            }
            else
            {
                setTimeout(initializeBanned, 50);
            }
        }
        initializeBanned();
    });
</script>
<section id="character_tools">
    <section id="select_character">
        <div class="table-responsive text-nowrap" style="text-align: center">
            <table class="nice_table mb-3">



                {if $rows}
                    <thead>
                    <tr>
                        <th scope="col" colspan="6" class="h4 text-center">
                            {lang("Server_fee", "status")}
                            {if $config->item('type_price_account')}
                                <img src="{$url}application/images/icons/coins_delete.png" width="20px" height="20px" align="absmiddle">
                                <span class="amount">   {$config->item('type_account')}  </span>
                                <span style="color: chocolate">  {$config->item('type_price_account')}  </span>
                            {else}
                                {lang("free", "status")}
                            {/if}
                        </th>
                    </tr>
                    </thead>
                    <thead>
                    <tr>
                        <th scope="col" colspan="6" class="h4 text-center">
                                {$this->user->getUsername()}  {$status}
                        </th>
                    </tr>
                    </thead>
                {/if}
                    <thead>
                    <tr>
                        <th>  {lang("ban_date", "status")}</th>
                        <th>  {lang("unban_date", "status")}</th>
                        <th>  {lang("unban_reason", "status")}</th>
                    </tr>
                    </thead>
                {if $rows}

                    {foreach from=$rows item=account}
                        <tr>
                            <td style="color: green" class="col-5"> {date("Y-m-d h:m:s A",$account.bandate)}</td>
                            <td style="color: green" class="col-5"> {date("Y-m-d h:m:s A",$account.unbandate)}</td>
                            <td style="color: green" class="col-5">{$account.banreason}</td>
                            <td style="color: green" class="col-5"></td>
                            <td>
                                <a href="javascript:void(0)" class="nice_button" onClick="Status.unbanAccount(this,'{$this->user->getUsername()}')">
                                    {lang("unban", "status")}
                                </a>
                            </td>
                        </tr>
                    {/foreach}
                {else}
                    <tr style="padding-top:10px;"><td> {lang("no_found_character", "status")} </td></tr>
                {/if}
            </table>
        </div>
    </section>

</section>
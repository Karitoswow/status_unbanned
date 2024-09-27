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
				<thead>
				<tr>
					<th scope="col" colspan="6" class="h4 text-center">
						{$realmName}
					</th>
				</tr>
				</thead>
				{if $this->totalBannedCharacters($realmid)}
				<thead>
				<tr>
					<th scope="col" colspan="6" class="h4 text-center">
						 {lang("Server_fee", "status")}
						{if $config->item('type_price_characters')}
							<img src="{$url}application/images/icons/coins_delete.png" width="20px" height="20px" align="absmiddle">
							<span class="amount">   {$config->item('type_characters')}  </span>
							<span style="color: chocolate">  {$config->item('type_price_characters')}  </span>
						{else}
							   {lang("free", "status")}
						{/if}
					</th>
				</tr>
				</thead>
				{/if}
				{if $this->totalBannedCharacters($realmid)}

					{foreach from=$this->getBannedChatacrer($realmid) item=character}
						<tr>
							<td class="col-0">
								<img src="{$url}application/images/stats/{$character.race}-{$character.gender}.gif">
							</td>
							<td>
								<img src="{$url}application/images/stats/{$character.class}.gif" width="20px">
							</td>
							<td>{$character.name}</td>
							<td class="col-5">Lv{$character.level}</td>
							<td>
								<div class="select_character">
									<div class="character store_item">
										<section class="character_buttons">
											<a href="javascript:void(0)" class="nice_button" onClick="Status.selectCharacter(this, {$realmid}, {$character.guid}, '{$character.name}')">
												Select
											</a>
										</section>
									</div>
								</div>
							</td>
						</tr>
						<thead id="header_{$realmid}_{$character.guid}" style="display: none;">
						<tr>
							<th>  {lang("ban_date", "status")}</th>
							<th>  {lang("unban_date", "status")}</th>
							<th>  {lang("unban_reason", "status")}</th>
						</tr>
						</thead>
						<tr id="view_{$realmid}_{$character.guid}" style="display: none;">
							<td style="color: green" class="col-5"> {date("Y-m-d h:m:s A",$character.bandate)}</td>
							<td style="color: green" class="col-5"> {date("Y-m-d h:m:s A",$character.unbandate)}</td>
							<td style="color: green" class="col-5">{$character.banreason}</td>
							<td style="color: green" class="col-5"></td>
							<td>
								<a href="javascript:void(0)" class="nice_button" onClick="Status.characterunban(this)">
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
var Status = {

	User: {

		dp: null,

		initialize: function(dp)
		{
			this.dp = dp;
		}
	},

	Character: {

		name: null,
		guid: null,
		realm: null,

		initialize: function(name, guid, realm)
		{
			this.name = name;
			this.guid = guid;
			this.realm = realm;
		}
	},

	selectCharacter: function(button, realm, guid, name)
	{
		var row = document.getElementById("view_" + realm + "_" + guid);
		var header = document.getElementById("header_" + realm + "_" + guid);

		$("tr[id^='view_'], thead[id^='header_']").hide();
		var CharSection = $("#select_character");

		Status.Character.initialize(name, guid, realm);

		$(".item_group", CharSection).each(function() {
			$(this).removeClass("item_group").addClass("select_character");
			$(this).find(".nice_active").removeClass("nice_active").html("Select");
		});

		$(button).parents(".select_character").removeClass("select_character").addClass("item_group");
		$(button).addClass("nice_active").html("Selected");

		$(row).show(); //
		$(header).show(); //
	},


	IsLoading: false,

	characterunban: function(button){

		if (Status.IsLoading)
			return;

		//Check if we have selected character
		if (Status.Character.guid == null){
			Swal.fire({
						icon:  'error',
						title: 'Status',
						text:  'Please select a character first.',
					})
			return;
		}
			$.ajax({
			  	beforeSend: function(xhr)
				{
					Status.IsLoading = true;
					$(button).parents(".select_tool").addClass("active_tool");
					$(button).html('Wait ...');

			  	}
			});
			$.post(Config.URL + "status/characterunban",
			{
				 
				guid: Status.Character.guid,
				realm: Status.Character.realm,
				csrf_token_name: Config.CSRF
			},
			function(data)
			{
				Status.IsLoading = false;
				
				if (data == 1)
				{
					Swal.fire({
						icon:  'success',
						title: 'Status',
						text:  'Character ' + Status.Character.name + ' unban successfully.',
						willClose: () => {
								window.location.reload();
						}
					});
				}
				else
				{
				Swal.fire({
						icon: 'error',
						title: 'Status',
						text: data,
					})
				}
				$(button).parents(".select_tool").addClass("active_tool");
				$(button).html('Status');
			});
		
	},
	unbanAccount: function(button,username){

		if (Status.IsLoading)
			return;


		$.ajax({
			beforeSend: function(xhr)
			{
				Status.IsLoading = true;
				$(button).parents(".select_tool").addClass("active_tool");
				$(button).html('Wait ...');

			}
		});
		$.post(Config.URL + "status/unbanAccount",
			{
				csrf_token_name: Config.CSRF
			},
			function(data)
			{
				Status.IsLoading = false;

				if (data == 1)
				{
					Swal.fire({
						icon:  'success',
						title: 'Status',
						text:  'Account ' + username + ' unban successfully.',
						willClose: () => {
							window.location.reload();
						}
					});
				}
				else
				{
					Swal.fire({
						icon: 'error',
						title: 'Status',
						text: data,
					})
				}
				$(button).parents(".select_tool").addClass("active_tool");
				$(button).html('Status');
			});

	}
}

function redirect(url) 
{
	window.location=url; 
}
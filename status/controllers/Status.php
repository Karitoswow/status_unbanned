<?php
use MX\MX_Controller;
class status extends MX_Controller
{
	public function __construct()
	{
		parent::__construct();

		$this->user->userArea();
		$this->load->config('config');
	}

	public function index()
	{
		$this->template->setTitle("َAccount Status");


		$content_data = array(

			"url" => $this->template->page_url,
			"this" => $this,
            "status" => $this->user->getAccountStatus(),
            "realms" => $this->realms->getRealms(),

		);
		
		$page_content = $this->template->loadPage("status.tpl", $content_data);
		
		//Load the page
		$page_data = array(
			"module" => "default", 
			"headline" => "Account Status",
			"content" => $page_content
		);
		
		$page = $this->template->loadPage("page.tpl", $page_data);
		
		$this->template->view($page, "modules/status/css/status.css", "modules/status/js/status.js");
	}

    public function characters($realmid)
    {
        $this->template->setTitle("َAccount Status - Banned Character");

        $content_data = array(

            "url" => $this->template->page_url,
            "dp" => $this->user->getDp(),
            "this" => $this,
            "realmid" => $realmid,
            "config" => $this->config,
            "realmName" => $this->getRealmname($realmid)

        );

        $page_content = $this->template->loadPage("characters.tpl", $content_data);

        //Load the page
        $page_data = array(
            "module" => "default",
            "headline" => "Banned Character",
            "content" => $page_content
        );

        $page = $this->template->loadPage("page.tpl", $page_data);

        $this->template->view($page, "modules/status/css/status.css", "modules/status/js/status.js");
    }


    public function account()
    {
        $this->template->setTitle("َAccount Status - Banned Account");

        $content_data = array(

            "url" => $this->template->page_url,
            "dp" => $this->user->getDp(),
            "this" => $this,
            "rows" => $this->getbannedAccount(),
            "config" => $this->config,
            "status" => $this->user->getAccountStatus(),

        );

        $page_content = $this->template->loadPage("account.tpl", $content_data);

        $page_data = array(
            "module" => "default",
            "headline" => "Banned Account",
            "content" => $page_content
        );

        $page = $this->template->loadPage("page.tpl", $page_data);

        $this->template->view($page, "modules/status/css/status.css", "modules/status/js/status.js");
    }
	
	public function characterunban()
	{

		$characterGuid = $this->input->post('guid'); 
		$realmId = $this->input->post('realm');
        $Price = $this->config->item("type_price");

        if($this->getOnlineAccount())
        {
            die("account is online");
        }
		if (!$this->realms->getRealm($realmId)->getEmulator()->hasConsole())
		{
				die(lang("relamdoesnotsupport","status"));
		}
		
		if ( $characterGuid && $realmId)
		{
				$realmConnection = $this->realms->getRealm($realmId)->getCharacters();
				$realmConnection->connect();

				if (!$realmConnection->characterExists($characterGuid))
				{
						die(lang("noselectedcharacter","status"));
				}

                $CharacterName = $this->getNameCharacter($realmId,$characterGuid);

                if($Price == 0) /// Free
                {
                    $this->realms->getRealm($realmId)->getEmulator()->sendCommand('.unban character '.$CharacterName);
                     die("1");
                }
				if ($this->user->getDp() >= $Price) // Only DP
				{

                    $this->realms->getRealm($realmId)->getEmulator()->sendCommand('.unban character '.$CharacterName);

					if ($Price > 0)
					{
						$this->user->setDp($this->user->getDp() - $Price);
				      	die("1");
					}
				}
				else 
				{
					die(lang("notenough","status"));
				}
		}
		else
		{
			die(lang("Theinputisinvalid","status"));
		}
	}

    public function unbanAccount()
    {

        $Price = $this->config->item("type_price_account");

            if($Price == 0) /// Free
            {
                $this->setUnBanAccount();
                die("1");
            }
            if ($this->user->getDp() >= $Price) // Only DP
            {
                if ($Price > 0)
                {
                    $this->user->setDp($this->user->getDp() - $Price);
                    $this->setUnBanAccount();
                    die("1");
                }
            }
            else
            {
                die(lang("notenough","status"));
            }

    }
    public function totalBannedCharacters($realmId = 1)
    {

        $character_database = $this->realms->getRealm($realmId)->getCharacters();
        $character_database->connect();
        $query = $character_database->getConnection()->query("SELECT COUNT(*) AS total FROM `characters` LEFT JOIN `character_banned` ON `characters`.`guid` = `character_banned`.`guid` WHERE `characters`.`account` = ? AND `character_banned`.`active` = 1", array($this->user->getId()));
        if ($query && $query->getNumRows() > 0)
        {
            $results = $query->getResultArray();

            return (int)$results[0]['total'];
        }
        return 0;
    }
    public function getBannedChatacrer($realmId = 1)
    {

        $character_database = $this->realms->getRealm($realmId)->getCharacters();
        $character_database->connect();
        $query = $character_database->getConnection()->query("SELECT * FROM `characters` LEFT JOIN `character_banned` ON `characters`.`guid` = `character_banned`.`guid` WHERE `characters`.`account` = ? AND `character_banned`.`active` = 1", array($this->user->getId()));
        if($query->getNumRows() > 0)
        {
            return $query->getResultArray();
        }
        else
        {
            return false;
        }
    }

    public function getNameCharacter($realmId,$guid)
    {

        $character_database = $this->realms->getRealm($realmId)->getCharacters();
        $character_database->connect();
        $query = $character_database->getConnection()->query("SELECT * FROM characters WHERE  guid = ? and account= ?", [$guid,$this->user->getId()]);
        if ($query && $query->getNumRows() > 0)
        {
            $results = $query->getResultArray();

            return $results[0]['name'];
        }
        return 0;
    }

    public function getOnlineAccount()
    {

        $this->connection = $this->external_account_model->getConnection();
        $query = $this->connection->query("SELECT * FROM account WHERE  id = ? AND online = 1",[$this->user->getId()]);
        if($query->getNumRows())
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public function getRealmname($realmid)
    {
        $query = $this->db->query("SELECT * FROM realms where  id = ?",[$realmid]);
        if($query->getNumRows() > 0)
        {
            $result=$query->getResultArray();
            return $result[0]['realmName'];
        }
        else
        {
            return false;
        }
    }

    public function getbannedAccount()
    {
        $this->connection = $this->external_account_model->getConnection();
        $query = $this->connection->query("SELECT " . columns("account_banned", ["id", "bandate", "unbandate", "bannedby", "banreason", "active"]) . " FROM " . table("account_banned") . " WHERE " . column("account_banned", "id") . " =?  and " . column("account_banned", "active") . " = 1 ", [$this->user->getId()]);
        if ($query->getNumRows() > 0)
            return  $query->getResultArray();
        else
            return false;
    }


    public function setUnBanAccount()
    {
        $this->connection = $this->external_account_model->getConnection();
        $this->connection->query("UPDATE " . table("account_banned") . " SET " . column("account_banned", "active") . " = 0 WHERE " . column("account_banned", "id") . " = ?", [$this->user->getId()]);
        return true;
    }

     
 }
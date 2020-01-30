 <cfquery name="LogAction" 
	 datasource="AppsSystem">
	INSERT INTO UserActionLog
	    (Account,NodeIP,ActionClass, ActionMemo) 
	VALUES (
	     '#url.id#',
		 '#CGI.Remote_Addr#',
		 'Logon',
		 'Successfull:#SESSION.acc#'
		 )
	</cfquery> 
	
	Unlocked
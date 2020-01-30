<cfparam name="attributes.marginTop"	default = "0px">

<style>
	/* Error template */
    .k-notification-error.k-group {
        background: 	rgba(222,83,122,0.6);
        color: 			#ffffff;
    }
	
	/* Success template */
    .k-notification-success.k-group {
        background: 	rgba(37,186,67,0.6);
        color: 			#ffffff;
    }
	
	/* Information template */
    .k-notification-information.k-group {
        background: 	rgba(67,177,232,0.6);
        color: 			#ffffff;
    }
	
    .notification-text {
		margin-top:		<cfoutput>#attributes.marginTop#</cfoutput>;
        width:			350px;
        height:			72px;
		font-family:	"Century Gothic", CenturyGothic, "Avant Garde", Avantgarde, "AppleGothic", Verdana, Arial, sans-serif;
    }
    .notification-text h3 {
        font-size:		15px;
		font-weight:	bold;
        padding: 		16px 5px 5px;
    }
	.notification-text p {
		margin-top:		<cfoutput>#attributes.marginTop#</cfoutput>;
        font-size:		12px;
    }
    .notification-text img {
        float: 			left;
        margin: 		15px;
		cursor:			pointer;
    }
</style>

<script id="_prosisErrorTemplate" type="text/x-kendo-template">
    <div class="notification-text k-notification-error k-group">
        <img src="<cfoutput>#session.root#</cfoutput>/images/error-icon.png" />
        <h3>#= title #</h3>
        <p>#= message #</p>
    </div>
</script>

<script id="_prosisSuccessTemplate" type="text/x-kendo-template">
	<div class="notification-text k-notification-success k-group">
		<img src="<cfoutput>#session.root#</cfoutput>/images/success-icon.png" />
		<h3>#= title #</h3>
		<p>#= message #</p>
	</div>
</script>

<script id="_prosisInformationTemplate" type="text/x-kendo-template">
	<div class="notification-text k-notification-information k-group">
		<img src="<cfoutput>#session.root#</cfoutput>/images/information-icon.png" />
		<h3>#= title #</h3>
		<p>#= message #</p>
	</div>
</script>

<span id="_prosisWindowNotification"></span>

<script>
	var _ProsisNotificationObject = $("#_prosisWindowNotification").kendoNotification({
				position: {
					pinned: true,
					top:60,
					right:30
				},
				autoHideAfter: 0,
				allowHideAfter: 500,
				stacking: "down",
				templates: [
					{
						type: "error",
						template: $("#_prosisErrorTemplate").html()
					},
					{
						type: "success",
						template: $("#_prosisSuccessTemplate").html()
					},
					{
						type: "information",
						template: $("#_prosisInformationTemplate").html()
					}
				]
			}).data("kendoNotification");
			
	function _ProsisNotificationObjectCustomShow(ptitle, pmessage, ptype, pdelay){ 
		_ProsisNotificationObject.setOptions({autoHideAfter:pdelay});
		_ProsisNotificationObject.show({title:ptitle,message:pmessage}, ptype);
	}
	
	function _ProsisNotificationObjectCustomHide() {
		_ProsisNotificationObject.hide();
	}
	
	function _ProsisNotification(){
		this.show = _ProsisNotificationObjectCustomShow;
		this.hide = _ProsisNotificationObjectCustomHide;
	}
	
	//Attaching the method to the Prosis object if exists
	if (!!Prosis) {
		Prosis.notification = new _ProsisNotification();
	}
	
</script>
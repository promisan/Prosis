<cfoutput>

	<script language="JavaScript">

	function pictureedit(path,dir,filter,height,width)	{	
		try{
			ColdFusion.Window.destroy('wApplicantPicture');
		}catch(err){}		
		ColdFusion.Window.create('wApplicantPicture','Picture',"#SESSION.root#/Tools/Picture/PictureDialog.cfm?path="+path+"&dir="+dir+'&filter='+filter+"&width="+width+"&height="+height+"&ts="+new Date().getTime(),{resizable:false,center:true,modal:true,width:530,height:350});
	}
		
	</script>
	
</cfoutput>	
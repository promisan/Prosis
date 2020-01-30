 <cfset sFactory = CreateObject("java","coldfusion.server.ServiceFactory")>
 <cfset MailSpoolService = sFactory.mailSpoolService>
 <cfset MailSpoolService.stop()>
 <cfset MailSpoolService.start()>
# Mendoza Digital Measures

Digital Measures provides a wonky HTTP API, and the Mendoza College of Business at Notre Dame wants to use that API to import data into a CMS. Rather than  delelop a CMS specific solution to do the import for just that one client, this library was built as a stand-alone gem. There has been some effort to make the code base generic enough to be used outside its specific requirement for Mendoza

For the gem to work, there must be an ENV variable accessible to the gem called "DIGITAL_MEASURES_CREDENTIALS" and the value to be "username:passphrase"

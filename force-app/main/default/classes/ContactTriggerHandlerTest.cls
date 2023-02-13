@isTest
public with sharing class ContactTriggerHandlerTest {
 

    /**
     * afterInsertHandlerTest2
     * from below method test data will be available to all test method
     * we can have only 1 testsetup() method per apex class
     */
    @TestSetup
    static void makeData(){
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(Name='Test1'));
        testAccounts.add(new Account(Name='Test2'));

        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(LastName = 'Test Contact1', AccountId = testAccounts[0].Id, Active__c = true));
        testContacts.add(new Contact(LastName = 'Test Contact2', AccountId = testAccounts[0].Id, Active__c = true));
        testContacts.add(new Contact(LastName = 'Test Contact3', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName = 'Test Contact4', AccountId = testAccounts[0].Id));
        testContacts.add(new Contact(LastName = 'Test Contact5', AccountId = testAccounts[1].Id));

        insert testContacts;

    }

    /**
     * afterInsertHandlerTest1
     * Check no of Active Contact on account After insertion
     * when active contacts = 0
     * We are testing for null value in this method
     * but we are also testing null value in afterInsertHandlerTest2 method for acc[1]
     * hence we don't need afterInsertHandlerTest1 & we can remove it
     */

    /**
     * afterInsertHandlerTest2
     * Check no of Active Contact on account After insertion
     * when active contacts > 0
     */
    @isTest
    public static void afterInsertHandlerTest2(){

        //Above code we haven't written anywhere Active_Contact__c to true
        //so it should be zero, now we retrieve account list and will check with assert statement
        List<Account> accs = [SELECT Id, Active_Contact__c FROM Account];

        for(Account acc: accs){
            if(acc.name == 'Test1'){
                System.assertEquals(2, accs[0].Active_Contact__c);
            }
            if(acc.name == 'Test2'){
                System.assertEquals(0, accs[1].Active_Contact__c);
            }
        }
        System.assertEquals(2, accs.size());

        //we can also test contact that we are inserting
        List<Contact> cons = [SELECT Id,Name, Active__c FROM Contact];
        System.assertEquals(5, cons.size());
    }

    /**
     * afterInsertHandlerTestBulk
     * Check no of Active Contact on account After bulk insertion
     */
    @isTest
    public static void afterInsertHandlerTestBulk(){

        Account testAccount1 = [SELECT Id FROM Account WHERE Name = 'Test1'];
        List<Contact> testContacts = new List<Contact>();
        for(Integer i=0; i<1000; i++){
            testContacts.add(new Contact(LastName = 'Test Contact'+i, AccountId = testAccount1.Id, Active__c=true));
        }

        insert testContacts;

        //Above code we haven't written anywhere Active_Contact__c to true
        //so it should be zero, now we retrieve account list and will check with assert statement
        List<Account> accs = [SELECT Id, Active_Contact__c FROM Account];

        for(Account acc: accs){
            if(acc.name == 'Test1'){
                System.assertEquals(1002, accs[0].Active_Contact__c);
            }
            if(acc.name == 'Test2'){
                System.assertEquals(0, accs[1].Active_Contact__c);
            }
        }
        System.assertEquals(2, accs.size());

        //we can also test contact that we are inserting
        List<Contact> cons = [SELECT Id,Name, Active__c FROM Contact];
        System.assertEquals(1005, cons.size());
    }

    /**
     * AfterUpdateHandlerTest
     * Check no of Active Contact on account After update
     */
    @isTest
    public static void AfterUpdateHandlerTest1(){

        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];
        for(Contact con: allContacts){

            //'Test Contact1' & 'Test Contact2' we are already checking in Test Setup method.
            //So below if condition we can check for 'Test Contact3' & 'Test Contact3'
            if(con.LastName == 'Test Contact3' || con.LastName == 'Test Contact4'){
                con.Active__c = true;
            }
        }

        //allocating new set of governer limit
        Test.startTest();
        update allContacts;
        Test.stopTest();

        //Quering over account to check active contact field value
        List<Account> accs = [SELECT Id, Active_Contact__c FROM Account];

        for(Account acc: accs){
            if(acc.name == 'Test1'){
                System.assertEquals(4, accs[0].Active_Contact__c);
            }
            if(acc.name == 'Test2'){
                System.assertEquals(0, accs[1].Active_Contact__c);
            }
        }
        System.assertEquals(2, accs.size());

        //we can also test contact that we are inserting
        List<Contact> cons = [SELECT Id,Name, Active__c FROM Contact];
        System.assertEquals(5, cons.size());
    }

    /**
     * AfterUpdateHandlerTest
     * Check no of Active Contact on account After update
     * And when Account (Id) is also get changed
     */
    @isTest
    public static void AfterUpdateHandlerTest2(){

        Account testAccount2 = [SELECT Id FROM Account WHERE Name = 'Test2'];
        List<Contact> allContacts = [SELECT Id, LastName FROM Contact];
        for(Contact con: allContacts){
            if(con.LastName == 'Test Contact3'){
                con.Active__c = true;
                con.AccountId = testAccount2.Id;
            }
        }

        //allocating new set of governer limit
        Test.startTest();
        update allContacts;
        Test.stopTest();

        //Quering over account to check active contact field value
        List<Account> accs = [SELECT Id,Name, Active_Contact__c FROM Account];

        for(Account acc: accs){
            if(acc.name == 'Test1'){
                System.assertEquals(2, accs[0].Active_Contact__c);
            }
            if(acc.name == 'Test2'){
                System.assertEquals(1, accs[1].Active_Contact__c);
            }
        }
        System.assertEquals(2, accs.size());

        //we can also test contact that we are inserting
        List<Contact> cons = [SELECT Id,Name, Active__c FROM Contact];
        System.assertEquals(5, cons.size());
    }

    /**
     * AfterUpdateHandlerTest
     * Check no of Active Contact on account After delete 
     */
    @isTest
    public static void AfterDeleteHandlerTest(){

        List<Contact> allContacts = [SELECT Id, LastName FROM Contact WHERE Name IN('Test Contact1','Test Contact5')];

        //allocating new set of governer limit
        Test.startTest();
        delete allContacts;
        Test.stopTest();

        //Quering over account to check active contact field value
        List<Account> accs = [SELECT Id, Active_Contact__c FROM Account];

        for(Account acc: accs){
            if(acc.name == 'Test1'){
                System.assertEquals(1, accs[0].Active_Contact__c);
            }
            if(acc.name == 'Test2'){
                System.assertEquals(0, accs[1].Active_Contact__c);
            }
        }
        System.assertEquals(2, accs.size());

        //we can also test contact that we are inserting
        List<Contact> cons = [SELECT Id,Name, Active__c FROM Contact];
        System.assertEquals(3, cons.size());
    }

    /**
     * AfterUpdateHandlerTest
     * Check no of Active Contact on account After delete 
     */
    @isTest
    public static void AfterUndeleteHandlerTest(){

        List<Contact> contactsToDelete = [SELECT Id, LastName FROM Contact WHERE Name IN('Test Contact1','Test Contact5')];
        //deleting Contacts
        delete contactsToDelete;

        //allocating new set of governer limit
        Test.startTest();
        Undelete contactsToDelete;
        Test.stopTest();

        //Quering over account to check active contact field value
        List<Account> accs = [SELECT Id, Active_Contact__c FROM Account];

        for(Account acc: accs){
            if(acc.name == 'Test1'){
                System.assertEquals(2, accs[0].Active_Contact__c);
            }
            if(acc.name == 'Test2'){
                System.assertEquals(0, accs[1].Active_Contact__c);
            }
        }
        System.assertEquals(2, accs.size());

        //we can also test contact that we are inserting
        List<Contact> cons = [SELECT Id,Name, Active__c FROM Contact];
        System.assertEquals(5, cons.size());
    }
}
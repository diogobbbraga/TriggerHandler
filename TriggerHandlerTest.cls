/* @author Diogo Braga */
@isTest
public with sharing class TriggerHandlerTest {
    @isTest
    public static void testNoOverride() {
        Boolean hasError = false;
        try {
            TestNoOverTriggerHandler testNoOverTriggerHandler = new TestNoOverTriggerHandler();
            testNoOverTriggerHandler.operationType = System.TriggerOperation.BEFORE_INSERT;
            testNoOverTriggerHandler.run();
            testNoOverTriggerHandler.runByRecordtype('test');
            testNoOverTriggerHandler.operationType = System.TriggerOperation.BEFORE_UPDATE;
            testNoOverTriggerHandler.run();
            testNoOverTriggerHandler.runByRecordtype('test');
            testNoOverTriggerHandler.operationType = System.TriggerOperation.BEFORE_DELETE;
            testNoOverTriggerHandler.run();
            testNoOverTriggerHandler.runByRecordtype('test');
            testNoOverTriggerHandler.operationType = System.TriggerOperation.AFTER_INSERT;
            testNoOverTriggerHandler.run();
            testNoOverTriggerHandler.runByRecordtype('test');
            testNoOverTriggerHandler.operationType = System.TriggerOperation.AFTER_UPDATE;
            testNoOverTriggerHandler.run();
            testNoOverTriggerHandler.runByRecordtype('test');
            testNoOverTriggerHandler.operationType = System.TriggerOperation.AFTER_DELETE;
            testNoOverTriggerHandler.run();
            testNoOverTriggerHandler.runByRecordtype('test');
            testNoOverTriggerHandler.operationType = System.TriggerOperation.AFTER_UNDELETE;
            testNoOverTriggerHandler.run();
            testNoOverTriggerHandler.runByRecordtype('test');
        } catch(Exception e) {
            hasError = true;
        }
        
        System.assert(!hasError, 'Erro durante contextualização da trigger');
    }
    
    public class TestNoOverTriggerHandler extends TriggerHandler {
        
    }
}

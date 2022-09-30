/**
 * My BDD Test
 */
component extends="coldbox.system.testing.BaseTestCase" accessors="true" {

    /*********************************** LIFE CYCLE Methods ***********************************/

    // executes before all suites+specs in the run() method
    function beforeAll() {
        super.beforeAll();
    }

    // executes after all suites+specs in the run() method
    function afterAll() {
        // super.afterAll();
    }

    /*********************************** BDD SUITES ***********************************/

    function run() {
        describe(
            title = 'createURL should',
            labels = 'automated',
            body = function() {
                beforeEach(function() {
                    fakeURL = mockData($type = 'words:1', $num = 1)[1];
                    fakeSecret = mockData($type = 'words:1', $num = 1)[1];
                    fakeSource = mockData($type = 'words:1', $num = 1)[1];
                    fakeDestType = mockData($type = 'words:1', $num = 1)[1];
                    fakeStore = mockData($type = 'oneOf:true:false', $num = 1)[1];

                    testobj = createmock(object = getInstance('imageConverter@cbConvertAPI'));
                    testObj.setapiSecret(fakeSecret);
                    testobj.setBaseURL(fakeURL);
                    testObj.setStoreFile(fakeStore);
                    testme = testObj.createUrl(fakesource, fakeDestType);
                });
                it('return a string with the assembled URL', function() {
                    expect(testme).tobe('#fakeURL#/#fakeSource#/to/#fakeDestType#?Secret=#fakeSecret#&StoreFile=#fakeStore#');
                });
                it('If a storeFile is submitted at runtime, that should override the default ', function() {
                    testme = testObj.createUrl(fakesource, fakeDestType, !fakeStore);
                    expect(testme).tobe('#fakeURL#/#fakeSource#/to/#fakeDestType#?Secret=#fakeSecret#&StoreFile=#!fakeStore#');
                });
            }
        );
    }

}

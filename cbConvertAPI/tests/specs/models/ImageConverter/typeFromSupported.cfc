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
                    fakeTypes = mockData($type = 'words:1', $num = 10);
                    testobj = createmock(object = getInstance('imageConverter@cbConvertAPI'));
                    testObj.setsourceTypesSupported(fakeTypes);
                    testme = testObj.typeFromSupported(fakeTypes[randRange(1, fakeTypes.len())]);
                });
                it('If the type submitted is in the sourceTypeSupported, return true', function() {
                    expect(testme).tobeTrue();
                });
                it('If the type submitted is NOT in the sourceTypeSupported, return true ', function() {
                    testme = testObj.typeFromSupported('FGIGDIGIDFIFDHIFdfdfgfd');
                    expect(testme).tobeFalse();
                });
            }
        );
    }

}

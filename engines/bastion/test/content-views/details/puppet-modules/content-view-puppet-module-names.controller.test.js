/**
 * Copyright 2014 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public
 * License as published by the Free Software Foundation; either version
 * 2 of the License (GPLv2) or (at your option) any later version.
 * There is NO WARRANTY for this software, express or implied,
 * including the implied warranties of MERCHANTABILITY,
 * NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
 * have received a copy of GPLv2 along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 **/

describe('Controller: ContentViewPuppetModuleNamesController', function() {
    var $scope, $controller, dependencies, ContentView;

    beforeEach(module('Bastion.content-views', 'Bastion.test-mocks'))

    beforeEach(inject(function($injector) {
        $controller = $injector.get('$controller');
        ContentView = $injector.get('MockResource').$new();
        ContentView.availablePuppetModuleNames = function () {};

        $scope = $injector.get('$rootScope').$new();
        $scope.transitionTo = function () {};
        $scope.$stateParams.contentViewId = 1;

        dependencies = {
            $scope: $scope,
            ContentView: ContentView
        };

        $controller('ContentViewPuppetModuleNamesController', dependencies);
    }));

    it("sets a names loading indicator on the $scope", function() {
        expect($scope.namesLoading).toBe(true);
    });

    it("sets the puppet module names on the $scope", function () {
        ContentView.availablePuppetModuleNames = function (data, callback) {
            callback();
        };

        spyOn(ContentView, 'availablePuppetModuleNames').andCallThrough();

        $controller('ContentViewPuppetModuleNamesController', dependencies);

        expect(ContentView.availablePuppetModuleNames).toHaveBeenCalledWith({id: 1}, jasmine.any(Function));
        expect($scope.namesLoading).toBe(false);
    });

    it("provides a way to select a new version of the puppet module", function () {
        spyOn($scope, 'transitionTo');

        $scope.selectVersion("puppet");

        expect($scope.transitionTo).toHaveBeenCalledWith('content-views.details.puppet-modules.versions',
            {contentViewId: 1, moduleName: "puppet"}
        );
    });
});

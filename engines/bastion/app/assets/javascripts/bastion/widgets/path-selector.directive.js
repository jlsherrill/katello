/**
 * Copyright 2013 Red Hat, Inc.
 *
 * This software is licensed to you under the GNU General Public
 * License as published by the Free Software Foundation; either version
 * 2 of the License (GPLv2) or (at your option) any later version.
 * There is NO WARRANTY for this software, express or implied,
 * including the implied warranties of MERCHANTABILITY,
 * NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
 * have received a copy of GPLv2 along with this software; if not, see
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
 */

/**
 * @ngdoc directive
 * @name Bastion.widgets.directive:pathSelector
 *
 * @description
 *   Provides a widget that renders a set of paths visually and allows
 *   users to select one or more paths depending on the configuration set.
 *
 * @example
 */
angular.module('Bastion.widgets').directive('pathSelector',
    function () {
    return {
        restrict: 'AE',
        require: '?ngModel',
        scope: {
            paths: '=pathSelector',
            mode: '@',
            disableTrigger: '=',
            enabledCheck: '&',
            pathAttribute: '@'
        },
        templateUrl: 'widgets/views/path-selector.html',
        link: function (scope, element, attrs, ngModel) {
            var activeItemId, convertPathObjects;

            scope.itemSelected = function (item) {
                if (item && scope.mode === 'singleSelect') {
                    unselectActive();
                    selectById(item.id);
                    activeItemId = item.id;
                }
            };

            convertPathObjects = function (paths) {
                if (scope.pathAttribute) {
                    paths =  _.pluck(paths, scope.pathAttribute);
                }
                return paths;
            };

            if (scope.paths.$promise) {
                scope.paths.$promise.then(function (paths) {
                    scope.paths = convertPathObjects(paths);
                    scope.itemSelected(ngModel.$modelValue);
                });
            } else {
                scope.paths = convertPathObjects(scope.paths);
                scope.itemSelected(ngModel.$modelValue);
            }

            ngModel.$render = function () {
                scope.itemSelected(ngModel.$modelValue);
            };

            scope.$watch('disableTrigger', function (disable) {
                forEachItem(function (item) {
                    item.disabled = disable;
                });
            });

            scope.checkEnabled = function (item) {
                var enabled = true;
                if (item.disabled) {
                    enabled = false;
                } else if (attrs.enabledCheck) {
                    enabled = scope.enabledCheck({item: item});
                }
                return enabled;
            };

            function selectById(id) {
                forEachItem(function (item) {
                    if (item.id === id) {
                        ngModel.$setViewValue(item);
                        item.selected = true;
                    }
                });
            }

            function unselectActive() {
                forEachItem(function (item) {
                    if (item.id === activeItemId) {
                        item.selected = false;
                    }
                });
            }

            function forEachItem(callback) {
                angular.forEach(scope.paths, function (path) {
                    angular.forEach(path, function (item) {
                        callback(item);
                    });
                });
            }
        }
    };
});

import { translate as __ } from 'foremanReact/common/I18n';
import Repos from '../../scenes/RedHatRepositories';
import Subscriptions from '../../scenes/Subscriptions';
import UpstreamSubscriptions from '../../scenes/Subscriptions/UpstreamSubscriptions/index';
import SubscriptionDetails from '../../scenes/Subscriptions/Details';
import SetOrganization from '../../components/SelectOrg/SetOrganization';
import WithOrganization from '../../components/WithOrganization/withOrganization';
import ModuleStreams from '../../scenes/ModuleStreams';
import ModuleStreamDetails from '../../scenes/ModuleStreams/Details';
import AnsibleCollections from '../../scenes/AnsibleCollections';
import AnsibleCollectionDetails from '../../scenes/AnsibleCollections/Details';
import Fruits from '../../scenes/Fruits';
import withHeader from './withHeaders';

// eslint-disable-next-line import/prefer-default-export
export const links = [
  {
    path: 'redhat_repositories',
    component: WithOrganization(withHeader(Repos, { title: __('RH Repos') })),
  },
  {
    path: 'subscriptions',
    component: WithOrganization(withHeader(Subscriptions, { title: __('Subscriptions') })),
  },
  {
    path: 'subscriptions/add',
    component: WithOrganization(withHeader(UpstreamSubscriptions, { title: __('Add Subscriptions') })),
  },
  {
    // eslint-disable-next-line no-useless-escape
    path: 'subscriptions/:id([0-9]+)',
    component: WithOrganization(withHeader(SubscriptionDetails, { title: __('Subscription Details') })),
  },
  {
    path: 'organization_select',
    component: SetOrganization,
  },
  {
    path: 'module_streams',
    component: withHeader(ModuleStreams, { title: __('Module Streams') }),
  },
  {
    path: 'module_streams/:id([0-9]+)',
    component: withHeader(ModuleStreamDetails, { title: __('Module Stream Details') }),
  },
  {
    path: 'ansible_collections',
    component: withHeader(AnsibleCollections, { title: __('Ansible Collections') }),
  },
  {
    path: 'ansible_collections/:id([0-9]+)',
    component: withHeader(AnsibleCollectionDetails, { title: __('Ansible Collection Details') }),
  },
  {
    path: 'fruits',
    component: withHeader(Fruits, { title: __('Fav Fruits') }),
  },
];

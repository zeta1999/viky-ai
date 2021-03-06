// App specific

// Sortable (https://github.com/RubaXa/Sortable)
import Sortable from 'sortablejs';
window.Sortable = Sortable;

// Mousetrap (https://github.com/ccampbell/mousetrap)
window.Mousetrap = require('mousetrap/mousetrap.js');
require('mousetrap/plugins/global-bind/mousetrap-global-bind.js')

// Trix (https://github.com/basecamp/trix)
window.Trix = require('trix');
import 'trix/dist/trix.css'

// MomentJS (https://momentjs.com/)
import 'moment'

// Autosize (https://github.com/jackmoore/autosize)
import 'autosize'

// Popper.js
import Popper from "popper.js"

// LocalTime (updated_at & cache)
import LocalTime from "local-time"
LocalTime.start()

import './nav/nav.coffee';

import './profile/main.scss';
import './profile/graph.coffee';

import './authentication/main.scss';

import './chatbots/main.scss';
window.App.Statement = require('./chatbots/statements');

import './play/main.scss';
import './play/chooser.coffee';
import './play/form.coffee';
window.App.PlayAside  = require('./play/aside.coffee');
window.App.PlayResult = require('./play/result.coffee');

import './agents/agent_form.coffee';
import './agents/main.scss';
import './agents/transfer_ownership_form.coffee';
window.App.AgentDuplicator = require('./agents/duplicator');

import './bots/main.scss';
import './bots/bot_form.coffee';

import './dependencies/dependencies_filter.coffee';

import './console/console.coffee';
import './console/console_explain_footer.coffee'
import './console/console_footer.coffee';
import './console/console_test_suite.coffee';
import './console/debug_solution.coffee';

import './interpretations/main.scss';
import './interpretations/interpretation_form.coffee';

import './entities_lists/main.scss';
import './entities_lists/entities_list_form.coffee';
import './entities_lists/entities_import_form.coffee';

window.App.EntitiesImport = require('./entities_lists/entities_import');

import './formulations/main.scss';
import './formulations/formulation_form.coffee';

import './entities/main.scss';

import './aliased_interpretations/main.scss';

import './readme/form.coffee';

import './backend/users/main.scss';

import './dashboard/main.scss';
import './dashboard/dashboard.coffee';

window.App.FormulationsList = require('./formulations/formulations_list');
window.App.EntityForm = require('./entities/entity_form');

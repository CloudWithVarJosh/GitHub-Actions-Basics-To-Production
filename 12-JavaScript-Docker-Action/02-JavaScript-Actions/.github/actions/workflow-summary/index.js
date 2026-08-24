const core = require("@actions/core");
const github = require("@actions/github");

try {

    const name = core.getInput("name");

    core.info("========================================");
    core.info("GitHub JavaScript Action");
    core.info("========================================");

    core.info("");
    core.info(`Hello ${name}!`);
    core.info("");

    core.info("Workflow Information");
    core.info("----------------------------------------");
    core.info(`Repository : ${github.context.repo.owner}/${github.context.repo.repo}`);
    core.info(`Workflow   : ${github.context.workflow}`);
    core.info(`Actor      : ${github.context.actor}`);
    core.info(`Event      : ${github.context.eventName}`);
    core.info(`Branch     : ${github.context.ref}`);
    core.info(`Run Number : ${github.context.runNumber}`);
    core.info(`SHA        : ${github.context.sha}`);

}
catch (error) {
    core.setFailed(error.message);
}
#!/usr/bin/env python
"""Stacker module for creating a CloudWatch Logs log group."""

from troposphere import logs, Export, GetAtt, Output, Ref, Sub
from stacker.blueprints.base import Blueprint
from stacker.blueprints.variables.types import CFNNumber, CFNString
from utils import standalone_output  # pylint: disable=relative-import


class LogGroup(Blueprint):
    """Extends Stacker Blueprint class."""

    VARIABLES = {
        'LogRetentionDays': {
            'type': CFNNumber,
            'description': 'The number of days log events are kept in'
                           ' CloudWatch Logs. When log event expires, it gets'
                           ' automatically deleted. Possible values are: 1, 3,'
                           ' 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400,'
                           ' 545, 731, 1827, and 3653 (default: 30)',
            'default': 30,
        },
        'LogGroupName': {
            'type': CFNString,
            'description': 'Name of log group to create',
        },
    }

    def add_resources_and_outputs(self):
        """Add resources and outputs to template."""
        template = self.template
        variables = self.get_variables()

        logsloggroup = template.add_resource(
            logs.LogGroup(
                'CloudWatchLogGroup',
                LogGroupName=variables['LogGroupName'].ref,
                RetentionInDays=variables['LogRetentionDays'].ref
            )
        )

        template.add_output(
            Output(
                '{}Arn'.format(logsloggroup.title),
                Description='CloudWatch Logs log group ARN',
                Value=GetAtt(logsloggroup, 'Arn'),
                Export=Export(
                    Sub('${AWS::StackName}-%sArn' % logsloggroup.title)
                )
            )
        )

        template.add_output(
            Output(
                '{}Name'.format(logsloggroup.title),
                Description='CloudWatch Logs log group name',
                Value=Ref(logsloggroup)
            )
        )

    def create_template(self):
        """Create template (main function called by Stacker)."""
        self.template.add_version('2010-09-09')
        self.template.add_description(
            'Creates a CloudWatch Logs log group'
        )
        self.add_resources_and_outputs()


# Helper section to enable easy blueprint -> template generation
# (just run `python <thisfile>` to output the json)
if __name__ == "__main__":
    from stacker.context import Context

    standalone_output.json(
        blueprint=LogGroup(
            'test', Context({"namespace": "test"}), None
        )
    )

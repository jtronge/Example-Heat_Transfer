cwlVersion: v1.0
class: Workflow
inputs: {}
  # TODO
outputs:
  # TODO
steps:
  # TODO: Add proper arguments and containers
  heat_transfer_adios2:
    run:
      class: CommandLineTool
      baseCommand: ./heat_transfer_adios2
      hints: {}
      arguments: []
      inputs: {}
      outputs: {}
    in: {}
    out: {}
  stager:
    run:
      class: CommandLineTool
      baseCommand: stage_write/stage_write
      hints: {}
      arguments: []
      inputs: {}
      outputs: {}
    in: {}
    out: {}
  # TODO

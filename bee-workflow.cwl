# BEE CWL version workflow with dummy inputs/outputs
# TODO: Use real CWL
class: Workflow
cwlVersion: v1.0
inputs:
  heat_input: string
requirements: {}
outputs: {}
steps:
  heat_transfer_adios2:
    run:
      class: CommandLineTool
      baseCommand: "/heat_transfer_adios2.sh"
      requirements: {}
      hints:
        DockerRequirement:
          dockerImageId: heat-transfer.tar.gz
      inputs:
        heat_input:
          type: string
      outputs:
        output:
          type: string
    in:
      heat_input: heat_input
    out: [output]
  stager:
    run:
      class: CommandLineTool
      baseCommand: "/stage_write.sh"
      requirements: {}
      hints:
        DockerRequirement:
          dockerImageId: heat-transfer.tar.gz
      inputs:
        heat_transfer_output:
          type: string
      outputs:
        output:
          type: string
    in:
      heat_transfer_output: heat_transfer_adios2/output
    out: [output]

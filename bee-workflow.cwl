# BEE CWL version workflow with dummy inputs/outputs
cwlVersion: v1.0
class: Workflow
inputs:
  heat_input: string
requirements: {}
outputs: {}
steps:
  heat_transfer_adios2:
    run:
      class: CommandLineTool
      baseCommand: "/heat_transfer_adios2.sh /tmp/heat HTPROC_X HTPROC_Y 40 50 6 500"
      requirements: {}
      hints: {}
        DockerRequirement:
          dockerImageId: heat-transfer.tar.gz
      inputs:
        heat_input:
          type: string
      outputs:
        output:
          type: string
    in:
      heat_input: heat_input:
    out: [output]
  stager:
    run:
      class: CommandLineTool
      baseCommand: "/stage_write.sh /tmp/heat.bp /tmp/stage.bp '' MPI ''"
      requirements: {}
      hints:
        DockerRequirement:
          dockerImageId: heat-transfer
      inputs:
        heat_transfer_output:
          type: string
      outputs:
        output:
          type: string
    in:
      heat_transfer_output: heat_transfer_adios2/output
    out: [output]

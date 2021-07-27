cwlVersion: v1.0
class: Workflow
inputs:
  heat_output: string
  stage_output: string
  htproc_x: integer
  htproc_y: integer
  array_x: integer
  array_y: integer
  steps: integer
  iterations: integer
  # write step inputs
  method: string
  write_params: string
  names: string
  transform_params: string
  # TODO
outputs:
  stage_output: string
steps:
  # TODO: Add proper arguments and containers
  heat_transfer_adios2:
    run:
      class: CommandLineTool
      baseCommand: [./heat_transfer_adios2]
      hints: {}
      requirements:
        cwltool:MPIRequirement:
          processes: $(inputs.htproc_x * inputs.htproc_y)
        DockerRequirement:
          dockerPull: jtronge/heat-transfer
      arguments: {}
      inputs:
        - id: output_prefix
          type: string
          inputBinding:
            position: 1
        - id: htproc_x
          type: integer
          inputBinding:
            position: 2
        - id: htproc_y
          type: integer
          inputBinding:
            position: 3
        - id: array_x
          type: integer
          inputBinding:
            position: 4
        - id: array_y
          type: integer
          inputBinding:
            position: 5
        - id: steps
          type: integer
          inputBinding:
            position: 6
        - id: iterations
          type: integer
          inputBinding:
            position: 7
      stdout: output.txt
      outputs: #{}
        output:
          type: stdout
    # in: {}
    in:
      output: heat_output
      htproc_x: htproc_x
      htproc_y: htproc_y
      array_x: array_x
      array_y: array_y
      steps: steps
      iterations: iterations
    out: # {}
      output: output
  stager:
    run:
      class: CommandLineTool
      baseCommand: [./stage_write/stage_write]
      arguments: []
      requirements:
        cwltool:MPIRequirement:
          processes: 3
        DockerRequirement:
          dockerPull: jtronge/heat-transfer
      hints: {}
      arguments: {}
      inputs:
        - id: heat_transfer_output
          type: string
        - id: input_path
          type: string
          inputBinding:
            position: 1
        - id: output_path
          type: string
          inputBinding:
            position: 2
        - id: method
          type: string
          inputBinding:
            position: 3
        - id: write_params
          type: string
          inputBinding:
            position: 4
        - id: names
          type: string
          inputBinding:
            position: 5
        - id: transform_params
          type: string
          inputBinding:
            position: 6
      outputs:
        output:
          type: stdout
    in: # {}
      heat_transfer_out: heat_transfer_adios2/output
      input_path: heat_output
      output_path: stage_output
      method: method
      write_params: write_params
      names: names
      transform_params: transform_params
    out: # {}
      output: output

cwlVersion: v1.0
class: Workflow
inputs:
  heat_output: string
  stage_output: string
  htproc_x: int
  htproc_y: int
  array_x: int
  array_y: int
  steps: int
  iterations: int
  # write step inputs
  method: string
  write_params: string
  names: string
  transform_params: string
  # TODO
requirements:
  InlineJavascriptRequirement: {}
outputs: {}
steps:
  # TODO: Add proper arguments and containers
  heat_transfer_adios2:
    run:
      class: CommandLineTool
      baseCommand: [/heat_transfer_adios2.sh]
      hints: {}
      requirements:
        #cwltool:MPIRequirement:
        #  processes: $(inputs.htproc_x * inputs.htproc_y)
        DockerRequirement:
          dockerPull: jtronge/heat-transfer
      arguments:
        - position: 1
          valueFrom: $(runtime.outdir + "/" + inputs.output_prefix)
      inputs:
        - id: output_prefix
          type: string
          #inputBinding:
          #  position: 1
        - id: htproc_x
          type: int
          inputBinding:
            position: 2
        - id: htproc_y
          type: int
          inputBinding:
            position: 3
        - id: array_x
          type: int
          inputBinding:
            position: 4
        - id: array_y
          type: int
          inputBinding:
            position: 5
        - id: steps
          type: int
          inputBinding:
            position: 6
        - id: iterations
          type: int
          inputBinding:
            position: 7
      outputs:
        output:
          type: File
          outputBinding:
            glob: '*.bp'
    in:
      output_prefix: heat_output
      htproc_x: htproc_x
      htproc_y: htproc_y
      array_x: array_x
      array_y: array_y
      steps: steps
      iterations: iterations
    out: [output]
  stager:
    run:
      class: CommandLineTool
      baseCommand: [/stage_write.sh]
      # baseCommand: [ls, .]
      arguments:
        - position: 1
          valueFrom: $(runtime.outdir + "/" + inputs.input_path + ".bp")
        - position: 2
          valueFrom: $(runtime.outdir + "/" + inputs.output_path)
      requirements:
        #cwltool:MPIRequirement:
        #  processes: 3
        InitialWorkDirRequirement:
          listing:
            - entry: $(inputs.heat_transfer_output)
        DockerRequirement:
          dockerPull: jtronge/heat-transfer
      hints: {}
      inputs:
        - id: heat_transfer_output
          type: File
        - id: input_path
          type: string
        - id: output_path
          type: string
          #inputBinding:
          #  position: 2
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
          type: File
          # TODO: Get this file value from the inputs
          outputBinding:
            glob: 'stage.bp'
    in:
      heat_transfer_output: heat_transfer_adios2/output
      input_path: heat_output
      output_path: stage_output
      method: method
      write_params: write_params
      names: names
      transform_params: transform_params
    out: [output]

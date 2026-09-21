import { BooleanLike } from 'tgui-core/react';
import { Box, Button, LabeledList, NumberInput, ProgressBar, Section } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { useBackend } from '../backend';
import { getGasColor } from '../constants';
import { Window } from '../layouts';

interface CrystallizerData {
  on: BooleanLike;
  requirements: string;
  internal_temperature: number;
  progress_bar: number;
  gas_input: number;
  selected: string;
  selected_recipes?: Recipe[];
  internal_gas_data?: Gas[];
}

interface Recipe {
  name: string;
  id: string;
}

interface Gas {
  name: string;
  id: string;
  amount: number;
}

const logScale = (value: number): number => Math.log2(16 + Math.max(0, value)) - 4;

export const Crystallizer = () => (
  <Window width={500} height={600}>
    <Window.Content scrollable>
      <Controls />
      <Requirements />
      <Gases />
    </Window.Content>
  </Window>
);

const Controls = () => {
  const { act, data } = useBackend<CrystallizerData>();
  const { gas_input, on, selected, selected_recipes = [] } = data;

  return (
    <Section title="Controls">
      <LabeledList>
        <LabeledList.Item label="Power">
          <Button
            icon={on ? 'power-off' : 'times'}
            content={on ? 'On' : 'Off'}
            selected={!!on}
            onClick={() => act('power')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Recipe">
          {selected_recipes.map(({ id, name }) => (
            <Button
              key={id || 'nothing'}
              selected={id === selected}
              content={name}
              onClick={() => act('recipe', { mode: id })}
            />
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Gas Input">
          <NumberInput
            animated
            value={gas_input}
            width="63px"
            unit="moles/s"
            minValue={0}
            maxValue={250}
            step={1}
            stepPixelSize={1}
            tickWhileDragging
            onChange={(value) => act('gas_input', { gas_input: value })}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const Requirements = () => {
  const { data } = useBackend<CrystallizerData>();
  const { requirements, internal_temperature, progress_bar } = data;

  return (
    <Section title="Requirements and progress">
      <LabeledList>
        <LabeledList.Item label="Progress">
          <ProgressBar
            value={progress_bar / 100}
            ranges={{
              good: [0.67, 1],
              average: [0.34, 0.66],
              bad: [0, 0.33],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Recipe">
          <Box m={1} preserveWhitespace>
            {requirements}
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <ProgressBar
            value={logScale(internal_temperature)}
            minValue={0}
            maxValue={logScale(10000)}
            ranges={{
              teal: [-Infinity, logScale(80)],
              good: [logScale(80), logScale(600)],
              average: [logScale(600), logScale(5000)],
              bad: [logScale(5000), Infinity],
            }}
          >
            {`${toFixed(internal_temperature)} K`}
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const Gases = () => {
  const { data } = useBackend<CrystallizerData>();
  const { internal_gas_data = [] } = data;

  return (
    <Section title="Gases">
      <LabeledList>
        {internal_gas_data.map(({ id, name, amount }) => (
          <LabeledList.Item key={id} label={name}>
            <ProgressBar color={getGasColor(id)} value={amount} minValue={0} maxValue={1000}>
              {`${toFixed(amount, 2)} moles`}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

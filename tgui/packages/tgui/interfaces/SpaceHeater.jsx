import { Box, Button, Icon, LabeledList, ProgressBar, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const SpaceHeater = (props) => {
  const { act, data } = useBackend();
  const { on, panel_open, set_temperature, cell_present, cell_charge } = data;

  if (!cell_present) {
    return <NoCell />;
  }

  return (
    <Window width={420} height={190}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title="Space Heater"
              buttons={
                <Button
                  icon={on ? 'power-off' : 'times'}
                  content={on ? 'On' : 'Off'}
                  selected={on}
                  disabled={panel_open}
                  onClick={() => act('toggle_power')}
                />
              }
            >
              <LabeledList>
                <LabeledList.Item label="Status">
                  {panel_open ? 'Panel open' : on ? 'Running' : 'Idle'}
                </LabeledList.Item>
                <LabeledList.Item label="Temperature">
                  <Button
                    icon="minus"
                    content="-5°C"
                    disabled={!panel_open}
                    onClick={() => act('temp', { value: -5 })}
                  />
                  <Box inline mx={1}>
                    {set_temperature}°C
                  </Box>
                  <Button icon="plus" content="+5°C" disabled={!panel_open} onClick={() => act('temp', { value: 5 })} />
                </LabeledList.Item>
                <LabeledList.Item label="Power Cell">
                  {cell_present ? (
                    <Button icon="eject" content="Remove" disabled={!panel_open} onClick={() => act('remove_cell')} />
                  ) : (
                    <Button icon="plus" content="Insert" disabled={!panel_open} onClick={() => act('insert_cell')} />
                  )}
                </LabeledList.Item>
                {!!cell_present && (
                  <LabeledList.Item label="Charge">
                    <ProgressBar
                      minValue={0}
                      maxValue={100}
                      value={cell_charge}
                      ranges={{ good: [50, Infinity], average: [15, 50], bad: [-Infinity, 15] }}
                    >
                      {cell_charge}%
                    </ProgressBar>
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const NoCell = (props) => {
  return (
    <Window width={420} height={190}>
      <Stack justify="center" align="center" fill vertical>
        <Icon.Stack>
          <Icon size="5" name="slash" />
          <Icon size="5" name="battery-quarter" />
        </Icon.Stack>
        <Box bold={1} color="bad">
          Please Insert Power Cell
        </Box>
      </Stack>
    </Window>
  );
};

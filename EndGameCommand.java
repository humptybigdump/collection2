package codefight.command;

import codefight.model.CodeFight;
import codefight.model.game.Phase;
import codefight.model.player.Player;

import java.util.ArrayList;
import java.util.List;
import java.util.StringJoiner;

/**
 * Represents the "end-game" command.
 *
 * @author ugmom
 */
final class EndGameCommand implements Command {
    private static final int EXCESS_SYMBOLS = 2;
    
    private static final String RUNNING_PLAYERS = "Running AIs: ";
    private static final String STOPPED_PLAYERS = "Stopped AIs: ";
    private static final String LIST_DIVIDER = ", ";
    private static final String HELP_MESSAGE = "Ends the game";
    
    @Override
    public CommandResult execute(CodeFight model, String[] commandArguments) {
        List<Player> participants = new ArrayList<>(model.getParticipants());
        StringBuilder running = new StringBuilder();
        StringBuilder stopped = new StringBuilder();
        StringJoiner output = new StringJoiner(System.lineSeparator());
        
        for (Player participant : participants) {
            if (!participant.hasStopped()) {
                running.append(participant).append(LIST_DIVIDER);
            } else {
                stopped.append(participant).append(LIST_DIVIDER);
            }
        }

        String endMessage;

        if (running.toString().isEmpty()) {
            buildMessage(stopped, output, STOPPED_PLAYERS);
            endMessage = output.toString();
        } else if (stopped.toString().isEmpty()) {
            buildMessage(running, output, RUNNING_PLAYERS);
            endMessage = output.toString();
        } else {
            buildMessage(running, output, RUNNING_PLAYERS);
            buildMessage(stopped, output, STOPPED_PLAYERS);
            endMessage = output.toString();
        }

        model.reset();
        return new CommandResult(CommandResultType.SUCCESS, endMessage);
    }
    private void buildMessage(StringBuilder builder, StringJoiner joiner, String prefix) {
        builder.delete(builder.length() - EXCESS_SYMBOLS, builder.length());
        builder.insert(0, prefix);
        joiner.add(builder);
    }

    @Override
    public String getHelpMessage() {
        return HELP_MESSAGE;
    }
    
    @Override
    public Phase getPhase() {
        return Phase.GAME_PHASE;
    }

    @Override
    public int requiredArguments() {
        return 0;
    }
}

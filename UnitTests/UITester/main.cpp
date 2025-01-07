#include <QtQuickTest/quicktest.h>
#include <QQuickStyle>

int main(int argc, char **argv)
{
    QQuickStyle::setStyle("Basic");
    QTEST_SET_MAIN_SOURCE_PATH

    int result = quick_test_main(argc, argv, "uitest", QUICK_TEST_SOURCE_DIR);
    return result;
}

## Вопросы и проблемы
С API iTunes было работать достаточно трудно, так как нет внятного контракта плюс возвращаются разные модели в одном массиве, что неудобно.
Пришлось почти все поля в модели опциональными сделать.
Также по ТЗ надо было в одной выдаче поддержать разные типы медиа, что и повлекло за собой вышеописанную проблему.
Даже а реальном приложении iTunes разные вкладки под разные типы медиа.

## Инструкции по запуску
При запуске откроется пустой экран с текст филдом сверху. Кнопка в правой части открывает экран с фильтрами и выбором кол-ва ответов сервера (limit).
Флоу примерно такой же как у приложения Авито. При начале ввода выскакивают подсказки, все как в ТЗ. По тапу на подсказку или по кнопке Return на клавиатуре произойдет поисковой запрос.
Среди ответов поддерживаются фильмы и песни, а также артисты и альбомы. Картинки кэшируются для улучшения производительности collection view.
На экране деталей тоже все по ТЗ. Снизу доп инфа плюс кнопка, по тапу на которую появится горизонтальное collection view с другими работами автора (переиспользуется с главного экрана).
Общий дизайн так себе, но все что нужно по ТЗ есть. Юнит тестами покрыл сетевой слой и маппинг json в модели. Общая архитектура MVVM, Combine для data binding, async/await.

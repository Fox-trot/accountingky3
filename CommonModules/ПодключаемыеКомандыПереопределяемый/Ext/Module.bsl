﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// С помощью ПриОпределенииВидовПодключаемыхКоманд можно определить собственные виды подключаемых команд,
// помимо уже предусмотренных в стандартной поставке (печатные формы, отчеты и команды заполнения).
//
// Параметры:
//   ВидыПодключаемыхКоманд - ТаблицаЗначений - поддерживаемые виды команд:
//       * Имя         - Строка            - имя вида команд. Должно удовлетворять требованиям именования переменных и
//                                           быть уникальным (не совпадать с именами других видов).
//                                           Может соответствовать имени подсистемы, отвечающей за вывод этих команд.
//                                           Следующие имена зарезервированы: "Печать", "Отчеты", "ЗаполнениеОбъектов".
//       * ИмяПодменю  - Строка            - имя подменю для размещения команд этого вида на формах объектов.
//       * Заголовок   - Строка            - наименование подменю, выводимое пользователю.
//       * Картинка    - Картинка          - картинка подменю.
//       * Отображение - ОтображениеКнопки - режим отображения подменю.
//       * Порядок     - Число             - порядок подменю в командной панели формы объекта по отношению 
//                                           к другим подменю. Используется при автоматическом создании подменю 
//                                           в форме объекта.
//
// Пример:
//
//	Вид = ВидыПодключаемыхКоманд.Добавить();
//	Вид.Имя         = "Мотиваторы";
//	Вид.ИмяПодменю  = "ПодменюМотиваторов";
//	Вид.Заголовок   = НСтр("ru = 'Мотиваторы'");
//	Вид.Картинка    = БиблиотекаКартинок.Информация;
//	Вид.Отображение = ОтображениеКнопки.КартинкаИТекст;
//	
Процедура ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт
	
	ПодключаемыеКомандыПереопределяемыйБП.ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд);	
	
КонецПроцедуры

// Позволяет расширить состав параметра Настройки процедуры ПриОпределенииНастроек в модулях менеджеров отчетов и 
// обработок, включенных в состав подсистемы ПодключаемыеОтчетыИОбработки, с помощью чего отчеты и обработки могут 
// сообщить о себе, что они предоставляют определенные виды команд и взаимодействуют с подсистемами через их 
// программный интерфейс.
//
// Параметры:
//  НастройкиПрограммногоИнтерфейса - ТаблицаЗначений:
//   * Ключ              - Строка        - имя настройки, например "ДобавитьМотиваторы".
//   * ОписаниеТипов     - ОписаниеТипов - тип настройки, например: Новый ОписаниеТипов("Булево").
//   * ВидыПодключаемыхОбъектов - Строка - имена видов объектов метаданных, для которых будет доступна эта настройка,
//                                             перечисленные через запятую. Например: "Отчет" или "Отчет, Обработка".
//
// Пример:
//  Для того чтобы в ПриОпределенииНастроек модуля обработки предусмотреть собственный признак ДобавитьМотиваторы:
//  Процедура ПриОпределенииНастроек(Настройки) Экспорт
//    Настройки.ДобавитьМотиваторы = Истина;  // вызывается процедура ДобавитьМотиваторы
//    Настройки.Размещение.Добавить(Метаданные.Документы.Анкеты);
//  КонецПроцедуры
//
//  следует реализовать следующий код:
//  Настройка = НастройкиПрограммногоИнтерфейса.Добавить();
//  Настройка.Ключ          = "ДобавитьМотиваторы";
//  Настройка.ОписаниеТипов = Новый ОписаниеТипов("Булево");
//  Настройка.ВидыПодключаемыхОбъектов = "Обработка";
//
Процедура ПриОпределенииСоставаНастроекПодключаемыхОбъектов(НастройкиПрограммногоИнтерфейса) Экспорт
	
	
	
КонецПроцедуры

// Вызывается однократно при первом формировании списка команд, выводимых в форме конкретного объекта конфигурации.
// Список добавленных команд следует вернуть в параметре Команды.
// Результат кэшируется с помощью модуля с повторными использованием возвращаемых значений (в разрезе имен форм).
//
// Параметры:
//   НастройкиФормы - Структура - сведения о форме, в которой выводятся команды. Для чтения:
//         * ИмяФормы - Строка - полное имя формы, в которой выводятся подключаемые команды. 
//                               Например, "Документ.Анкета.ФормаСписка".
//   
//   Источники - ДеревоЗначений - сведения о поставщиках команд этой формы. 
//         На втором уровне дерева могут располагаться источники, регистрируемые автоматически при регистрации владельца.
//         Например, документы-регистраторы журналов:
//         * Метаданные - ОбъектМетаданных - метаданные объекта.
//         * ПолноеИмя  - Строка           - полное имя объекта. Например: "Документ.ИмяДокумента".
//         * Вид        - Строка           - вид объекта в верхнем регистре. Например: "СПРАВОЧНИК".
//         * Менеджер   - Произвольный     - модуль менеджера объекта, или Неопределено, если у объекта 
//                                           нет модуля менеджера или если его не удалось получить.
//         * Ссылка     - СправочникСсылка.ИдентификаторыОбъектовМетаданных - ссылка объекта метаданных.
//         * ЭтоЖурналДокументов - Булево - Истина, если объект является журналом документов.
//         * ТипСсылкиДанных     - Тип
//                               - ОписаниеТипов - тип ссылки элемента.
//   
//   ПодключенныеОтчетыИОбработки - ТаблицаЗначений - отчеты и обработки, предоставляющие свои команды 
//         для объектов Источники:
//         * ПолноеИмя - Строка       - полное имя объекта метаданных.
//         * Менеджер  - Произвольный - модуль менеджера объекта метаданных.
//         Состав колонок см. в ПодключаемыеКомандыПереопределяемый.ПриОпределенииСоставаНастроекПодключаемыхОбъектов.
//   
//   Команды - ТаблицаЗначений - записать в этот параметр сформированные команды для вывода в подменю: 
//       * Вид - Строка - вид команды.
//           Подробнее см. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд.
//       * Идентификатор - Строка - идентификатор команды.
//       
//     Настройки внешнего вида:
//       * Представление - Строка   - представление команды в форме.
//       * Важность      - Строка   - суффикс подгруппы в меню, в которой следует вывести эту команду.
//                                    Допустимо использовать: "Важное", "Обычное" и "СмТакже".
//       * Порядок       - Число    - порядок размещения команды в группе. Используется для настройки под конкретное
//                                    рабочее место. Допустимо задавать в диапазоне от 1 до 100. По умолчанию порядок 50.
//       * Картинка      - Картинка - картинка команды. Необязательный.
//       * СочетаниеКлавиш - СочетаниеКлавиш - сочетание клавиш для быстрого вызова команды. Необязательный.
//       * ТолькоВоВсехДействиях - Булево - отображать команду только в меню Еще.
//     
//     Настройки видимости и доступности:
//       * ТипПараметра - ОписаниеТипов - типы объектов, для которых предназначена эта команда.
//       * ВидимостьВФормах    - Строка - имена форм через запятую, в которых должна отображаться команда.
//                                        Используется, когда состав команд отличается для различных форм.
//       * Назначение          - Строка - определяет вид форм, для которых предназначена команда. 
//                                        Принимаемые значения:
//                                         "ДляСписка" - показывать команду только в форме списка,
//                                         "ДляОбъекта" - показывать команду только в форме объекта.
//                                        Если параметр не указан, то команда предназначена для любых видов форм.
//       * ФункциональныеОпции - Строка - имена функциональных опций через запятую, определяющих видимость команды.
//       * УсловияВидимости    - Массив - определяет видимость команды в зависимости от контекста.
//                                        Для регистрации условий следует использовать процедуру
//                                        ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды().
//                                        Условия объединяются по "И".
//       * ИзменяетВыбранныеОбъекты - Булево - определяет доступность команды в ситуации,
//                                        когда у пользователя нет прав на изменение объекта.
//                                        Если Истина, то в описанной выше ситуации кнопка будет недоступна.
//                                        Необязательный. Значение по умолчанию - Ложь.
//     
//     Настройки процесса выполнения:
//       * МножественныйВыбор - Булево - если Истина, то команда поддерживает множественный выбор.
//             В этом случае в параметре выполнения будет передан список ссылок.
//             Необязательный. Значение по умолчанию - Истина.
//       * РежимЗаписи - Строка - действия, связанные с записью объекта, которые выполняются перед обработчиком команды:
//             ** "НеЗаписывать"          - объект не записывается, а в параметрах обработчика вместо ссылок передается
//                                          вся форма. В этом режиме рекомендуется работать напрямую с формой,
//                                          которая передается в структуре 2-го параметра обработчика команды.
//             ** "ЗаписыватьТолькоНовые" - записывать новые объекты.
//             ** "Записывать"            - записывать новые и модифицированные объекты.
//             ** "Проводить"             - проводить документы.
//             Перед записью и проведением у пользователя запрашивается подтверждение.
//             Необязательный. Значение по умолчанию - "Записывать".
//       * ТребуетсяРаботаСФайлами - Булево - если Истина, то в веб-клиенте предлагается
//             установить расширение для работы с 1С:Предприятием. Необязательный. Значение по умолчанию - Ложь.
//     
//     Настройки обработчика:
//       * Менеджер - Строка - объект, отвечающий за выполнение команды.
//       * ИмяФормы - Строка - имя формы, которую требуется получить для выполнения команды.
//           Если Обработчик не указан, то у формы вызывается метод "Открыть".
//       * ИмяПараметраФормы - Строка - имя параметра формы, в который следует передать ссылку или массив ссылок.
//       * ПараметрыФормы - Неопределено
//                        - Структура - параметры формы, указанной в ИмяФормы. Необязательный.
//       * Обработчик - Строка - описание процедуры, обрабатывающей основное действие команды, в виде:
//           "<ИмяОбщегоМодуля>.<ИмяПроцедуры>", если процедура размещена в общем модуле;
//           либо "<ИмяПроцедуры>" - в следующих случаях:
//             - если ИмяФормы заполнено, то в модуле указанной формы ожидается клиентская процедура;
//             - если ИмяФормы не заполнено, то в модуле менеджера этого объекта ожидается серверная процедура.
//       * ДополнительныеПараметры - Структура - параметры обработчика, указанного в Обработчик. Необязательный.
//
Процедура ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт
	
	ПодключаемыеКомандыПереопределяемыйБП.ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды);	
	
КонецПроцедуры

#КонецОбласти

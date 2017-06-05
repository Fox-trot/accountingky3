﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Новости".
// ОбщийМодуль.ОбработкаНовостейКлиентСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработкаХТМЛ

// Функция возвращает текст, обрамленный тегами HTML.
//
// Параметры:
//  Текст        - Строка - сам текст, который надо вывести;
//  Жирный       - Булево - Истина, если текст надо обрамить жирностью;
//  Курсив       - Булево - Истина, если текст надо обрамить курсивом;
//  Подчеркнутый - Булево - Истина, если текст надо обрамить подчеркиванием;
//  ЦветТекста   - Строка - FFFFFF, (длина 6);
//  Гиперссылка  - Строка - гиперссылка текста.
//
// Возвращаемое значение:
//  Строка - текст в формате HTML.
//
Функция ПолучитьФорматированнуюСтроку(
			ЗНАЧ Текст,
			Жирный = Ложь, Курсив = Ложь, Подчеркнутый = Ложь,
			ЦветТекста = Неопределено, Гиперссылка = "") Экспорт

	ТипСтрока = Тип("Строка");

	Если Жирный = Истина Тогда
		Текст = "<B>" + Текст + "</B>";
	КонецЕсли;

	Если Курсив = Истина Тогда
		Текст = "<I>" + Текст + "</I>";
	КонецЕсли;

	Если Подчеркнутый = Истина Тогда
		Текст = "<U>" + Текст + "</U>";
	КонецЕсли;

	Если ТипЗнч(ЦветТекста) = ТипСтрока Тогда
		Текст = "<FONT COLOR=""#%ЦветТекста%"">" + Текст + "</FONT>";
		Текст = СтрЗаменить(Текст, "%ЦветТекста%", ЦветТекста);
	КонецЕсли;

	Если НЕ ПустаяСтрока(Гиперссылка) Тогда
		Текст = "<A HREF=""%Гиперссылка%"">" + Текст + "</A>";
		Текст = СтрЗаменить(Текст, "%Гиперссылка%", Гиперссылка);
	КонецЕсли;

	Возврат Текст;

КонецФункции

// Функция возвращает текст, обрамленный тегами HTML.
//
// Параметры:
//  МассивТекстов - Массив - Массив простых и форматированных текстов.
//
// Возвращаемое значение:
//  Строка - текст в формате HTML.
//
Функция ПолучитьФорматированныйТекст(МассивТекстов) Экспорт

	Текст = "";

	Для каждого ТекущийЭлементМассива Из МассивТекстов Цикл
		Если ТекущийЭлементМассива = Символы.ПС Тогда
			Текст = Текст + "<br/>";
		Иначе
			Текст = Текст + ТекущийЭлементМассива;
		КонецЕсли;
	КонецЦикла;

	Возврат Текст;

КонецФункции

// Функция заменяет специальные символы в коде HTML для правильного отображения новости.
//
// Параметры:
//  Текст - Строка - Код HTML, который необходимо подкорректировать.
//
// Возвращаемое значение:
//   Строка - откорректированный код HTML.
//
Функция ЗаменитьСпециальныеСимволыВHTML(Текст) Экспорт

	Результат = Текст;

	// Если разделителем строк вместо символа 13 будет 10, то inline-картинки (<img src="data:image/png;base64,) НЕ будут отображаться.
	// Необходимо заменить символы с кодом 10 на 13.
	Результат = СтрЗаменить(Результат, Символ(13) + Символ(10), Символ(13));
	Результат = СтрЗаменить(Результат, Символ(10) + Символ(13), Символ(13));
	Результат = СтрЗаменить(Результат, Символ(10), Символ(13));
	// Остальные замены.
	// Один символ перевода строки не заменять! Это разрушит inline-base64-картинки.
	Результат = СтрЗаменить(Результат, Символ(13) + Символ(13), "<#br#/><#br#/>");
	// Пробел с переводом строки заменить на <br/>.
	Результат = СтрЗаменить(Результат, " " + Символ(13), "<#br#/>");
	// Заменить неявные переводы строк <*>13 на <*> - удалить 13, если он идет сразу после тега.
	// Потому-что это может повлиять на отображение таблиц, которые удобно редактировать с переводами строк.
	Результат = СтрЗаменить(Результат, ">" + Символ(13), ">");
	// Перевод строки неявно заменить на <br/>.
	Результат = СтрЗаменить(Результат, "<#br#/>", "<br/>");

	Возврат Результат;

КонецФункции

// Функция ищет в тексте новости комментарий вида <!-- {Идентификатор} {Содержимое} --> и возвращает {Содержимое}.
// Разработчикам необходимо учесть факт, что при наличии комментариев "Идентификатор", "Идентификатор1", ... при попытке
//  поиска по "Идентификатор" будут найдены и "Идентификатор" и "Идентификатор1",
//  т.к. не обрабатывается анализ следующего символа после идентификатора - это символ или пробел или перевод строки.
// Эту возможность можно использовать для передачи в тексте новости произвольных параметров, например текст для отображения
//  в другой произвольной обработке (когда не подходят Заголовок, Подзаголовок и ТекстНовости).
//
// Параметры:
//  ДанныеНовости            - Строка, СправочникСсылка.Новости - где искать необходимый комментарий;
//  ИдентификаторКомментария - Строка - идентификатор, по которому необходимо найти данные;
//  ВозвращатьЕслиНеНайдено  - Произвольный - что возвращать, если комментарий не найден.
//
// Возвращаемое значение:
//   Строка или значение параметра функции ВозвращатьЕслиНеНайдено - содержимое комментария.
//
Функция ПолучитьСодержимоеИменованногоКомментария(ДанныеНовости, ИдентификаторКомментария, ВозвращатьЕслиНеНайдено = "") Экспорт

	ТипСтрока  = Тип("Строка");
	ТипНовость = Тип("СправочникСсылка.Новости");

	ТекстПоиска = "";

	Результат = ВозвращатьЕслиНеНайдено;

	Если ТипЗнч(ДанныеНовости) = ТипСтрока Тогда
		ТекстНовости = ДанныеНовости;
	ИначеЕсли ТипЗнч(ДанныеНовости) = ТипНовость Тогда
		ТекстНовости = ДанныеНовости.ТекстНовости;
	КонецЕсли;

	Если НЕ ПустаяСтрока(ТекстНовости) Тогда

		ТегНачала = "<!-- " + ИдентификаторКомментария;
		ТегКонца  = "-->";
		ГдеНачало = СтрНайти(ТекстНовости, ТегНачала);
		Если ГдеНачало > 0 Тогда
			ГдеКонец = СтрНайти(ТекстНовости, ТегКонца, , ГдеНачало);
			Если ГдеКонец > 0 Тогда
				Результат = Сред(ТекстНовости, ГдеНачало + СтрДлина(ТегНачала), ГдеКонец - ГдеНачало - СтрДлина(ТегНачала));
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область КонтекстныеНовости

// Функция создает подменю "Новости" для отображения контекстных новостей.
//
// Параметры:
//  Форма                  - УправляемаяФорма - форма, в которой необходимо разместить подменю;
//  ЭлементКоманднаяПанель - ЭлементФормы - командная панель, в конце которой будет размещено подменю "Новости";
//  ТаблицаНовостей        - ТаблицаЗначений - таблица, в которой должны быть колонки:
//    * Новость              - СправочникСсылка.Новости - ссылка на новость;
//    * НовостьНаименование  - Строка - заголовок новости;
//    * ДатаПубликации       - Дата - Дата публикации новости;
//    * Важность             - Число - важность новости (длина (1));
//    * ЭтоПостояннаяНовость - Булево - ИСТИНА, если новость постоянная (находится вверху списка).
//
// Возвращаемое значение:
//   ГруппаФормы - Созданный элемент управления.
//
Функция ДобавитьПодменюПросмотраСпискаНовостей(
			Форма,
			ЭлементКоманднаяПанель,
			ТаблицаНовостей) Экспорт

	ТипМассив = Тип("Массив");

	ЭлементПодменюНовости = Неопределено;

	Если (ТипЗнч(ЭлементКоманднаяПанель) = Тип("ГруппаФормы")) Тогда
		// Создать в командной панели подменю "Новости" (если его еще нет).
		ЭлементПодменюНовости = Форма.Элементы.Найти("Новость_ПодменюНовости");
		Если ЭлементПодменюНовости = Неопределено Тогда // Еще подменю не создавали
			ЭлементПодменюНовости = Форма.Элементы.Добавить("Новость_ПодменюНовости", Тип("ГруппаФормы"), ЭлементКоманднаяПанель);
			ЭлементПодменюНовости.Заголовок = НСтр("ru='Новости'");
			ЭлементПодменюНовости.Вид       = ВидГруппыФормы.Подменю;
			ЭлементПодменюНовости.Картинка  = БиблиотекаКартинок.Новости;
		КонецЕсли;

		Если (ТипЗнч(ЭлементПодменюНовости) = Тип("ГруппаФормы")) Тогда

			Если (ТипЗнч(ТаблицаНовостей) = Тип("ДанныеФормыКоллекция")
					ИЛИ ТипЗнч(ТаблицаНовостей) = Тип("ТаблицаЗначений")
					ИЛИ ТипЗнч(ТаблицаНовостей) = ТипМассив) Тогда // Массив структур

				Если (ТаблицаНовостей.Количество() > 0) Тогда

					// Вначале очистить подменю.
					Для каждого ЭлементПодменю Из ЭлементПодменюНовости.ПодчиненныеЭлементы Цикл
						Форма.Элементы.Удалить(ЭлементПодменю);
					КонецЦикла;

					// Очистить команды формы, начинающиеся с "Команда_Новость_".
					Для каждого ТекущаяКоманда Из Форма.Команды Цикл
						Если Найти(ВРег(ТекущаяКоманда.Имя), ВРег("Команда_Новость_")) = 1 Тогда
							Форма.Команды.Удалить(ТекущаяКоманда.Имя);
						КонецЕсли;
					КонецЦикла;

					// Подменю будет состоять из трех блоков: Постоянные новости, Новости и ссылка на общий список.

					// Добавить несколько первых новостей.
					//  Количество таких новостей = ОбработкаНовостейКлиентСерверПереопределяемый.РазмерПодменюПостоянныхКонтекстныхНовостей().
					// В таблице могут быть повторения (новость для формы элемента и формы списка), поэтому новость добавлять только один раз.
					ПодменюПостоянныхНовостей = Форма.Элементы.Добавить("ПодменюНовости_ПодменюСпискаПостоянныхНовостей", Тип("ГруппаФормы"), ЭлементПодменюНовости);
					ПодменюПостоянныхНовостей.Заголовок = НСтр("ru='Подменю списка постоянных новостей'");
					ПодменюПостоянныхНовостей.Вид       = ВидГруппыФормы.ГруппаКнопок;
					СписокДобавленныхНовостей = Новый СписокЗначений;
					С = 5;
					ОбработкаНовостейКлиентСерверПереопределяемый.ПереопределитьРазмерПодменюПостоянныхКонтекстныхНовостей(С);
					Для каждого ТекущаяНовость Из ТаблицаНовостей Цикл
						Если ТекущаяНовость.ЭтоПостояннаяНовость = Истина Тогда
							НайденнаяСтрока = СписокДобавленныхНовостей.НайтиПоЗначению(ТекущаяНовость.Новость);
							Если НайденнаяСтрока = Неопределено Тогда
								СписокДобавленныхНовостей.Добавить(ТекущаяНовость.Новость);

								НайденнаяНовость = ТекущаяНовость.НомерСтрокиНовости;
								Идентификатор = "Новость_" + НайденнаяНовость;

								НоваяКоманда = Форма.Команды.Добавить("Команда_" + Идентификатор);
								НоваяКоманда.Действие = "Подключаемый_ОбработкаНовости"; // ОбработкаНовости

								ПунктМеню = Форма.Элементы.Добавить(Идентификатор, Тип("КнопкаФормы"), ПодменюПостоянныхНовостей);
								ПунктМеню.ИмяКоманды = НоваяКоманда.Имя;
								// Постоянные новости выводятся без даты.
								ПунктМеню.Заголовок  = ТекущаяНовость.НовостьНаименование;

								С = С - 1;
								Если С <= 0 Тогда
									Прервать;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;

					// Добавить несколько (ОбработкаНовостейКлиентСерверПереопределяемый.ПереопределитьРазмерПодменюКонтекстныхНовостей())
					//  первых новостей.
					// В таблице могут быть повторения (новость для формы элемента и формы списка), поэтому новость добавлять только один раз.
					ПодменюНовостей = Форма.Элементы.Добавить("ПодменюНовости_ПодменюСпискаНовостей", Тип("ГруппаФормы"), ЭлементПодменюНовости);
					ПодменюНовостей.Заголовок = НСтр("ru='Подменю списка новостей'");
					ПодменюНовостей.Вид       = ВидГруппыФормы.ГруппаКнопок;
					СписокДобавленныхНовостей = Новый СписокЗначений;
					С = 10;
					ОбработкаНовостейКлиентСерверПереопределяемый.ПереопределитьРазмерПодменюКонтекстныхНовостей(С);
					Для каждого ТекущаяНовость Из ТаблицаНовостей Цикл
						Если ТекущаяНовость.ЭтоПостояннаяНовость = Ложь Тогда
							НайденнаяСтрока = СписокДобавленныхНовостей.НайтиПоЗначению(ТекущаяНовость.Новость);
							Если НайденнаяСтрока = Неопределено Тогда
								СписокДобавленныхНовостей.Добавить(ТекущаяНовость.Новость);

								НайденнаяНовость = ТекущаяНовость.НомерСтрокиНовости;
								Идентификатор = "Новость_" + НайденнаяНовость;

								НоваяКоманда = Форма.Команды.Добавить("Команда_" + Идентификатор);
								НоваяКоманда.Действие = "Подключаемый_ОбработкаНовости"; // ОбработкаНовости

								ПунктМеню = Форма.Элементы.Добавить(Идентификатор, Тип("КнопкаФормы"), ПодменюНовостей);
								ПунктМеню.ИмяКоманды = НоваяКоманда.Имя;
								// Новости выводятся с датой.
								ПунктМеню.Заголовок  = Формат(ТекущаяНовость.ДатаПубликации, "ДЛФ=D") + " - " + ТекущаяНовость.НовостьНаименование;
								Если (ТекущаяНовость.Важность = 1) Тогда
									ПунктМеню.Картинка = БиблиотекаКартинок.ВажностьНовостиОченьВажная;
								ИначеЕсли (ТекущаяНовость.Важность = 2) Тогда
									ПунктМеню.Картинка = БиблиотекаКартинок.ВажностьНовостиВажная;
								КонецЕсли;

								С = С - 1;
								Если С <= 0 Тогда
									Прервать;
								КонецЕсли;
							КонецЕсли;
						КонецЕсли;
					КонецЦикла;

					// Добавить ссылку на форму списка новостей.
					НоваяКоманда = Форма.Команды.Добавить("Команда_Новость_Список");
					НоваяКоманда.Действие    = "Подключаемый_ОбработкаНовости";
					НоваяКоманда.Картинка    = БиблиотекаКартинок.Новости;
					НоваяКоманда.Отображение = ОтображениеКнопки.КартинкаИТекст;

					ПунктМеню = Форма.Элементы.Добавить("Новость_Список", Тип("КнопкаФормы"), ЭлементПодменюНовости);
					ПунктМеню.ИмяКоманды = "Команда_Новость_Список";
					ПунктМеню.Заголовок  = НСтр("ru='Все новости по этой теме'");

				КонецЕсли;
			КонецЕсли;

			ОбработкаНовостейКлиентСерверПереопределяемый.ПослеДобавленияПодменюПросмотраСпискаНовостей(
				Форма,
				ЭлементКоманднаяПанель,
				ЭлементПодменюНовости,
				ТаблицаНовостей);

		КонецЕсли;

	КонецЕсли;

	Возврат ЭлементПодменюНовости;

КонецФункции

// Функция создает кнопку "Новости" для отображения списка контекстных новостей.
//
// Параметры:
//  Форма                  - УправляемаяФорма - форма, в которой необходимо разместить кнопку;
//  ЭлементКоманднаяПанель - ЭлементФормы - командная панель, в конце которой будет размещена кнопка "Новости";
//  ТаблицаНовостей        - ТаблицаЗначений - таблица, в которой должны быть колонки:
//    * Новость              - СправочникСсылка.Новости - ссылка на новость;
//    * НовостьНаименование  - Строка - заголовок новости;
//    * ДатаПубликации       - Дата - Дата публикации новости;
//    * Важность             - Число - важность новости (длина (1));
//    * ЭтоПостояннаяНовость - Булево - ИСТИНА, если новость постоянная (находится вверху списка).
//
// Возвращаемое значение:
//   КнопкаФормы - Созданный элемент управления.
//
Функция ДобавитьКнопкуПросмотраСпискаНовостей(
			Форма,
			ЭлементКоманднаяПанель,
			ТаблицаНовостей) Экспорт

	КомандаНовость = Неопределено;

	Если (ТипЗнч(ЭлементКоманднаяПанель) = Тип("ГруппаФормы")) Тогда

		// Очистить команды формы, начинающиеся с "Команда_Новость_".
		Для каждого ТекущаяКоманда Из Форма.Команды Цикл
			Если Найти(ВРег(ТекущаяКоманда.Имя), ВРег("Команда_Новость_")) = 1 Тогда
				Форма.Команды.Удалить(ТекущаяКоманда.Имя);
			КонецЕсли;
		КонецЦикла;

		КомандаНовость = Форма.Команды.Добавить("Команда_Новость_Список");
		КомандаНовость.Действие    = "Подключаемый_ОбработкаНовости"; // ОбработкаНовости
		КомандаНовость.Картинка    = БиблиотекаКартинок.Новости;
		КомандаНовость.Отображение = ОтображениеКнопки.КартинкаИТекст;
		КомандаНовость.Подсказка   = НСтр("ru='Нажмите для открытия списка контекстных новостей'");

		КнопкаНовостей = Форма.Элементы.Добавить("КнопкаНовостей", Тип("КнопкаФормы"), ЭлементКоманднаяПанель);
		КнопкаНовостей.Заголовок             = НСтр("ru='Новости'");
		КнопкаНовостей.Вид                   = ВидКнопкиФормы.КнопкаКоманднойПанели;
		КнопкаНовостей.ИмяКоманды            = КомандаНовость.Имя;
		КнопкаНовостей.ТолькоВоВсехДействиях = Ложь;

		ОбработкаНовостейКлиентСерверПереопределяемый.ПослеДобавленияКнопкиПросмотраСпискаНовостей(
			Форма,
			ЭлементКоманднаяПанель,
			КнопкаНовостей,
			ТаблицаНовостей);

	КонецЕсли;

	Возврат КомандаНовость;

КонецФункции

#КонецОбласти

#Область ОбработкаСтрок

// Функция возвращает количество новостей прописью.
//
// Параметры:
//  КоличествоНовостей - Число - количество новостей;
//
// Возвращаемое значение:
//  Строка - количество новостей прописью.
//
Функция КоличествоНовостейПрописью(КоличествоНовостей) Экспорт

	Результат = 
		НРег(
			ЧислоПрописью(
				КоличествоНовостей,
				"НП=Истина; НД=Ложь;",
				НСтр("ru='новость,новости,новостей,ж,,,,,0'")));

	Возврат Результат;

КонецФункции

// Функция возвращает строку доступных для задания кода символов - английские буквы, цифры, минус, подчеркивание и т.п.
//
// Возвращаемое значение:
//  Строка - список символов, разрешенных для использования в идентификаторах.
//
Функция РазрешенныеДляИдентификацииСимволы() Экспорт

	Результат = "_-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область БуферОбмена

// Возвращает пустую структуру для заполнения данными буфера обмена.
// Для использования в качестве буфера обмена Массив Структур, в отличие от ТаблицыЗначений,
//  может существовать и на клиенте и на сервере.
//
// Параметры:
//  КлючОбъекта  - Строка - Ключ, с которым данные будут сохранены в ХранилищеНастроек.БуферОбмена.
//
// Возвращаемое значение:
//   Структура - пустая Структура со всеми необходимыми полями.
//
Функция ПолучитьСтруктуруПолейБуфераОбмена(КлючОбъекта) Экспорт

	Результат = Новый Структура;

	Если ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииПростые") Тогда
		Результат = Новый Структура("КатегорияНовостей, КатегорияНовостейКод, УсловиеОтбора, ЗначениеКатегорииНовостей, ЗначениеКатегорииНовостейКод, Автор");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.КатегорииИнтервалыВерсий") Тогда
		Результат = Новый Структура("КатегорияНовостей, КатегорияНовостейКод, Продукт, ПродуктКод, ВерсияОТ, ВерсияДО, ПредставлениеИнтервалаВерсий, Автор");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПривязкаКМетаданным") Тогда
		Результат = Новый Структура("Метаданные, Форма, Событие, ПоказыватьВФормеОбъекта, Важность, ДатаСбросаВажности, ДатаСбросаВажностиМестная, ЭтоПостояннаяНовость, ДатаСбросаПостояннойНовости, ДатаСбросаПоказаВФормеОбъекта");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.БинарныеДанные") Тогда
		Результат = Новый Структура("УИН, Заголовок, ИнтернетСсылка, ПорядокСортировки, ДанныеСтрока64, ДанныеРазмер");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.Действия") Тогда
		Результат = Новый Структура("УИНДействия, Действие, ПараметрыДействий");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Документы.Новости.ПараметрыДействий") Тогда
		Результат = Новый Структура("Параметр, ЗначениеПараметра");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.Родители") Тогда
		Результат = Новый Структура("Продукт, ВерсияПродукта, ВерсияОТ, ВерсияДО, ВерсииСинхронизированы, ПредставлениеИнтервалаВерсий");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Справочники.Продукты.КаналыРаспространенияНовостей") Тогда
		Результат = Новый Структура("КаналРаспространенияНовостей, ВерсияОТ, ВерсияДО, ПредставлениеИнтервалаВерсий");
	ИначеЕсли ВРег(КлючОбъекта) = ВРег("Справочники.Пользователи.ПраваДоступаКТематическимПодборкам") Тогда
		Результат = Новый Структура("ТематическаяПодборка, Чтение, Изменение, Публикация, ОтменаПубликации");
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ПолучениеНастроекКонфигурации

// Возвращает адрес команды открытия списка новостей.
// Если подсистема ИПП выключена из командного интерфейса, то вернуть
//   e1cib/command/Справочник.Новости.Команда.КомандаСписокНовостей.
// Если подсистема ИнтернетПоддержкаПользователей включена в командный интерфейс (хотя может быть и не видна), то вернуть
//   e1cib/navigationpoint/ИнтернетПоддержкаПользователей/Справочник.Новости.Команда.КомандаСписокНовостей.
// Так как наша система должна быть выключена из командного интерфейса, то всегда возвращать первый вариант.
// В случае внедрения в демобазу (когда подсистема включена в командный интерфейс), использовать:
//   Результат = "e1cib/navigationpoint/ИнтернетПоддержкаПользователей/Справочник.Новости.Команда.КомандаСписокНовостей";
//
// Параметры:
//  Нет.
//
// Возвращаемое значение
//  Строка - актуальный адрес команды открытия формы списка новостей.
//
Функция ПолучитьНавигационнуюСсылкуСпискаНовостей() Экспорт

	Результат = "e1cib/command/Справочник.Новости.Команда.КомандаСписокНовостей"; // Если подсистема НЕ внедрена в командный интерфейс

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЛогИОтладка

// Функция возвращает массив всех возможных событий журнала регистрации для событий подсистемы.
// Нужно для формирования журнала регистрации из Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//   Массив - Массив всех возможных событий.
//
Функция ПолучитьСписокВсехСобытийЖурналаРегистрации() Экспорт

	Результат = Новый Массив;

	Результат.Добавить("БИП:Новости.Разное");
	Результат.Добавить("БИП:Новости.Клиент");
	Результат.Добавить("БИП:Новости.Отладка");
	Результат.Добавить("БИП:Новости.Все обновления новостей");
	Результат.Добавить("БИП:Новости.Сервис и регламент");
	Результат.Добавить("БИП:Новости.Обновление ИБ");
	Результат.Добавить("БИП:Новости.Загрузка новостей");
	Результат.Добавить("БИП:Новости.Загрузка классификаторов");
	Результат.Добавить("БИП:Новости.Хранилище настроек новостей");
	Результат.Добавить("БИП:Новости.Переопределяемый");
	Результат.Добавить("БИП:Новости.Изменение данных");

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти
